import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/UserModel.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
    print(currentUser.phoneNumber);
    return UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        photoUrlFull: currentUser.photoUrl,phoneNumber: currentUser.phoneNumber);
  }

  Future signOutGoogle() async {
    await googleSignIn.signOut();
    await deleteToken();
    await deleteLocalUserInfo();
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

  Future<UserModel> getUserInfo() async {
    UserModel authUserInfo;
    bool hasUserInfo = await hasLocalUserInfo();
    if (hasUserInfo == false) {
      authUserInfo = await signInWithGoogle();
      await persistUserInfo(authUserInfo);
    } else {
      authUserInfo = await readLocalUserInfo();
    }

    return authUserInfo;
  }

  Future<void> deleteLocalUserInfo() async {
    await Future.delayed(Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_user_info');
  }
}
