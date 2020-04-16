import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StringUtils {
  static String capitalizeWord(String str) {
    try {
      List<String> words = str.toLowerCase().split(RegExp("\\s"));
      String capitalizeWord = "";
      for (String w in words) {
        String first = w.substring(0, 1);
        String afterFirst = w.substring(1);
        capitalizeWord += first.toUpperCase() + afterFirst + " ";
      }
      return capitalizeWord.trim();
    } catch (e) {
      print(e.toString());
      return str;
    }
  }

  static String replaceSpaceToUnderscore(String str) {
    try {
      return str.replaceAll(' ', '_');
      ;
    } catch (e) {
      print(e.toString());
      return str;
    }
  }
}

Future<String> userDataUrlAppend(GoogleSignInAccount signInAccount, String url) async {

  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (url == null) {
    return url;
  } else {
    Map<String, String> usrMap = {
      '_googleIDToken_': '',
      '_userUID_': '',
      '_userName_': '',
      '_userEmail_': ''
    };

    if (firebaseUser != null && signInAccount != null) {

      GoogleSignInAuthentication signInAuthentication =
          await signInAccount.authentication;

      usrMap = {
        '_googleIDToken_': signInAuthentication.idToken,
        '_userUID_': firebaseUser.uid,
        '_userName_': firebaseUser.displayName,
        '_userEmail_': firebaseUser.email
      };
    }

    usrMap.forEach((key, value) {
      url = url.replaceAll(key, value);
    });

    return Platform.isAndroid ? url : Uri.encodeFull(url);
  }
}
