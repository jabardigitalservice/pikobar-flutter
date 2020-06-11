import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:meta/meta.dart';

openChromeSafariBrowser({@required String url}) async {
  await FlutterWebBrowser.openWebPage(url: url, androidToolbarColor: Colors.white);
}