import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/UserModel.dart';
import 'package:pikobar_flutter/utilities/LocationService.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return UserModel(
        googleIdToken: googleSignInAuthentication.idToken,
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        photoUrlFull: currentUser.photoUrl,
        phoneNumber: currentUser.phoneNumber);
  }

  Future signOut() async {
    await removeFCMToken();
    await googleSignIn.signOut().then((value) {
      _auth.signOut();
    });
    await deleteToken();
    await deleteLocalUserInfo();
  }

  /// Sign In with Apple
  ///
  /// User info is only sent in the ASAuthorizationAppleIDCredential upon initial
  /// user sign in. Subsequent logins to your app using Sign In with Apple with
  /// the same account do not share any user info and will only return a user
  /// identifier in the ASAuthorizationAppleIDCredential.
  Future<UserModel> signInWithApple() async {
    /// Perform the sign-in request
    /// the requestedScopes are email and fullName
    /// see: https://developer.apple.com/documentation/authenticationservices/asauthorization/scope
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    /// Check the result
    /// the three possible cases are [AuthorizationStatus.authorized],
    /// [AuthorizationStatus.error] and [AuthorizationStatus.cancelled].
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _auth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;

        if (appleIdCredential.fullName.givenName != null) {
          /// Update the firebase display name
          /// from the data provided by appleIdCredential.
          String displayName =
              "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";

          final updateUser = UserUpdateInfo();
          updateUser.displayName = displayName;
          await user.updateProfile(updateUser);

          /// If the name on the user document firestore is null,
          /// update the name from the data provided by appleIdCredential.
          ///
          /// This is required to prevent errors due to a null value of name.
          final userDocument =
              Firestore.instance.collection(kUsers).document(user.uid);

          await userDocument.get().then((snapshot) async {
            if (snapshot.exists && snapshot.data['name'] == null) {
              await userDocument.updateData({'name': displayName});
            }
          });
        }

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);

        return UserModel(
            googleIdToken:
                String.fromCharCodes(appleIdCredential.identityToken),
            uid: currentUser.uid,
            email: currentUser.email,
            name: currentUser.displayName,
            photoUrlFull: currentUser.photoUrl,
            phoneNumber: currentUser.phoneNumber);

      case AuthorizationStatus.error:
        throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString());

      case AuthorizationStatus.cancelled:
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
    return null;
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    return;
  }

  Future<void> persistToken(String uid) async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    await prefs.setString('uid', uid);
    return;
  }

  Future<void> persistUserInfo(UserModel authUserInfo) async {
    final prefs = await SharedPreferences.getInstance();
    Map authUserInfoJson = authUserInfo.toJson();
    await prefs.setString('auth_user_info', json.encode(authUserInfoJson));
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') == null ? false : true;
  }

  Future<String> getToken() async {
    /// read from keystore/keychain
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<bool> hasLocalUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_user_info') == null ? false : true;
  }

  Future<UserModel> readLocalUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String userInfoJsonString = prefs.getString('auth_user_info');
    Map userInfoMap = json.decode(userInfoJsonString);
    return UserModel.fromJson(userInfoMap);
  }

  Future<UserModel> getUserInfo({bool isApple = false}) async {
    try {
      UserModel authUserInfo;
      bool hasUserInfo = await hasLocalUserInfo();
      if (hasUserInfo == false) {
        if (Platform.isIOS && isApple) {
          authUserInfo = await signInWithApple();
        } else {
          authUserInfo = await signInWithGoogle();
        }

        await persistUserInfo(authUserInfo);
        await registerFCMToken();
        await LocationService.actionSendLocation();
      } else {
        authUserInfo = await readLocalUserInfo();
      }

      return authUserInfo;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateIdToken() async {
    if (await _auth.currentUser() != null && await hasToken()) {
      UserModel currentUser = await getUserInfo();
      if (currentUser.googleIdToken == null) {
        GoogleSignInAuthentication signInAuthentication;

        if (googleSignIn.currentUser != null) {
          signInAuthentication = await googleSignIn.currentUser.authentication;
        } else {
          GoogleSignInAccount signInAccount =
              await googleSignIn.signInSilently();
          signInAuthentication = await signInAccount.authentication;
        }

        UserModel user = UserModel(
            googleIdToken: signInAuthentication.idToken,
            uid: currentUser.uid,
            email: currentUser.email,
            name: currentUser.name,
            photoUrlFull: currentUser.photoUrlFull,
            phoneNumber: currentUser.phoneNumber);

        await persistUserInfo(user);
      }
    }
  }

  Future<void> deleteLocalUserInfo() async {
    await Future.delayed(Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_user_info');
  }

  Future<void> registerFCMToken() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    if (_user != null) {
      final userDocument =
          Firestore.instance.collection(kUsers).document(_user.uid);

      _firebaseMessaging.getToken().then((token) {
        final tokensDocument =
            userDocument.collection(kUserTokens).document(token);

        tokensDocument.get().then((snapshot) {
          if (!snapshot.exists) {
            tokensDocument
                .setData({'token': token, 'created_at': DateTime.now()});
          }
        });
      });

      FirebaseAnalytics().setUserId(_user.uid);

      userDocument.get().then((snapshot) {
        if (snapshot.exists && snapshot.data['city_id'] != null) {
          FirebaseAnalytics().setUserProperty(
              name: 'city_id', value: snapshot.data['city_id']);
        }
      });
    }
  }

  Future<void> removeFCMToken() async {
    UserModel authUserInfo = await getUserInfo();

    await _firebaseMessaging.getToken().then((token) async {
      final tokensDocument = Firestore.instance
          .collection(kUsers)
          .document(authUserInfo.uid)
          .collection(kUserTokens)
          .document(token);

      await tokensDocument.get().then((snapshot) async {
        if (snapshot.exists) {
          await tokensDocument.delete();
        }
      });
    });
  }
}
