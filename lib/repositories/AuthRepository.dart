import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/UserModel.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
import 'package:pikobar_flutter/utilities/LocationService.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum Auth { login, logout }

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    return UserModel(
        googleIdToken: googleSignInAuthentication.idToken,
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        photoUrlFull: currentUser.photoURL,
        phoneNumber: currentUser.phoneNumber);
  }

  Future signOut() async {
    await removeFCMToken();
    await googleSignIn.signOut().then((value) async {
      await _auth.signOut();
    }, onError: (error) {
      print(error.toString());
    });
    await deleteToken();
    await deleteLocalUserInfo();
    await LocationService.stopBackgroundLocation();
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
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _auth.signInWithCredential(credential);
        final User user = authResult.user;

        if (appleIdCredential.fullName.givenName != null) {
          /// Update the firebase display name
          /// from the data provided by appleIdCredential.
          String displayName =
              "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";

          await user.updateProfile(displayName: displayName);

          /// If the name on the user document firestore is null,
          /// update the name from the data provided by appleIdCredential.
          ///
          /// This is required to prevent errors due to a null value of name.
          final userDocument =
              FirebaseFirestore.instance.collection(kUsers).doc(user.uid);

          await userDocument.get().then((snapshot) async {
            if (snapshot.exists && getField(snapshot, 'name') == null) {
              await userDocument.update({'name': displayName});
            }
          });
        }

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        return UserModel(
            googleIdToken:
                String.fromCharCodes(appleIdCredential.identityToken),
            uid: currentUser.uid,
            email: currentUser.email,
            name: currentUser.displayName,
            photoUrlFull: currentUser.photoURL,
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
        await cloudFunctionOnAuth(authType: Auth.login);
        await LocationService.configureBackgroundLocation(
            userInfo: authUserInfo);
      } else {
        authUserInfo = await readLocalUserInfo();
      }

      return authUserInfo;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateIdToken() async {
    if (_auth.currentUser != null && await hasToken()) {
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
    User _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      final userDocument =
          FirebaseFirestore.instance.collection(kUsers).doc(_user.uid);

      await _firebaseMessaging.getToken().then((token) {
        final tokensDocument = userDocument.collection(kUserTokens).doc(token);

        tokensDocument.get().then((snapshot) {
          if (!snapshot.exists) {
            tokensDocument.set({'token': token, 'created_at': DateTime.now()});
          }
        });
      });

      await FirebaseAnalytics().setUserId(_user.uid);

      await userDocument.get().then((snapshot) {
        if (snapshot.exists && getField(snapshot, 'city_id') != null) {
          FirebaseAnalytics().setUserProperty(
              name: 'city_id', value: getField(snapshot, 'city_id'));
        }
      });
    }
  }

  /// Send information to the cloud function
  /// when the user login or logout
  ///
  /// The data passed into the trigger [call] can be any of the following types:
  ///
  /// `null`
  /// `String`
  /// `num`
  /// [List], where the contained objects are also one of these types.
  /// [Map], where the values are also one of these types.
  ///
  /// The request to the Cloud Functions backend made by this method
  /// automatically includes a Firebase Instance ID token to identify the app
  /// instance. If a user is logged in with Firebase Auth, an auth ID token for
  /// the user is also automatically included.
  Future<void> cloudFunctionOnAuth({@required Auth authType}) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'userOnAuth',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));

    try {
      await callable.call(
        <String, dynamic>{
          'auth_type': authType.toString().split('.').last,
          'fcm_token': await _firebaseMessaging.getToken()
        },
      );
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> removeFCMToken() async {
    UserModel authUserInfo = await getUserInfo();

    await _firebaseMessaging.unsubscribeFromTopic('self_reports');

    await _firebaseMessaging.getToken().then((token) async {
      final tokensDocument = FirebaseFirestore.instance
          .collection(kUsers)
          .doc(authUserInfo.uid)
          .collection(kUserTokens)
          .doc(token);

      await tokensDocument.get().then((snapshot) async {
        if (snapshot.exists) {
          await tokensDocument.delete();
        }
      }, onError: (error) {
        print(error.toString());
      });
    });
  }
}
