import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:pikobar_flutter/models/UserModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

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
    } catch (e) {
      print(e.toString());
      return str;
    }
  }

  static bool containsWords(String inputString, List<String> items) {
    bool found = false;
    for (String item in items) {
      if (inputString.contains(item)) {
        found = true;
        break;
      }
    }
    return found;
  }
}

Future<String> userDataUrlAppend(String url) async {
  if (url == null) {
    return url;
  } else {
    Map<String, String> usrMap = {
      '_googleIDToken_': '',
      '_userUID_': '',
      '_userName_': '',
      '_userEmail_': ''
    };

    bool hasLocalUserInfo = await AuthRepository().hasLocalUserInfo();
    if (hasLocalUserInfo) {
      UserModel user = await AuthRepository().readLocalUserInfo();
      if (user != null) {
        usrMap = {
          '_googleIDToken_': '${user.googleIdToken}',
          '_userUID_': '${user.uid}',
          '_userName_': '${user.name}',
          '_userEmail_': '${user.email}'
        };
      }
    }

    usrMap.forEach((key, value) {
      url = url.replaceAll(key, value);
    });

    return Platform.isAndroid ? url : Uri.encodeFull(url);
  }
}

Future<void> launchUrl({BuildContext context, String url}) async {
  List<String> items = [
    '_googleIDToken_',
    '_userUID_',
    '_userName_',
    '_userEmail_'
  ];
  if (StringUtils.containsWords(url, items)) {
    bool hasToken = await AuthRepository().hasToken();
    if (!hasToken) {
      bool isLoggedIn = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));

      if (isLoggedIn != null && isLoggedIn) {
        url = await userDataUrlAppend(url);

        openChromeSafariBrowser(url: url);
      }
    } else {
      url = await userDataUrlAppend(url);
      openChromeSafariBrowser(url: url);
    }
  } else {
    openChromeSafariBrowser(url: url);
  }
}

Future<Uint8List> bytesImageFromHtmlString(String htmlString) async {
  try {
    var document = parse(htmlString);
    String urlImage = document.getElementsByTagName('img')[0].attributes['src'];
    var request = await HttpClient().getUrl(Uri.parse(urlImage));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    return bytes;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<String> stringFromHtmlString(String htmlString) async {
  String removedTag = htmlString
      .replaceAll(RegExp('<\s*br[^>]*>'), '\n');

  removedTag = removedTag.replaceAll(RegExp('<\s*p[^>]*>'), '\n\n')
      .replaceAll(RegExp('<\s*\/\s*p\s*>'), '');

  removedTag = removedTag.replaceAll(RegExp('<\s*ul[^>]*>'), '')
      .replaceAll(RegExp('<\s*\/\s*ul\s*>'), '')
      .replaceAll(RegExp('<\s*ol[^>]*>'), '')
      .replaceAll(RegExp('<\s*\/\s*ol\s*>'), '');

  removedTag = removedTag.replaceAll(RegExp('<\s*li[^>]*>'), '\n')
      .replaceAll(RegExp('<\s*\/\s*li\s*>'), '');

  var document = parse(removedTag);
  String parsedString = parse(document.body.text).documentElement.text;
  return parsedString;
}
