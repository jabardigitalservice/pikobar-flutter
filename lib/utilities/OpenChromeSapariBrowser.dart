import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/Colors.dart';

openChromeSafariBrowser({@required String url}) async {
  await FlutterWebBrowser.openWebPage(url: url, androidToolbarColor: ColorBase.green);
}