import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InWebView extends StatefulWidget {
  final String url;

  InWebView({this.url});

  @override
  _InWebViewState createState() => _InWebViewState();
}

class _InWebViewState extends State<InWebView> {

  WebViewController controllerGlobal;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitWebView(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Dictionary.appName),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                controllerGlobal = webViewController;
              },
              onPageStarted: (url) {
                setState(() {
                  showLoading = true;
                });
              },
              onPageFinished: (url) {
                setState(() {
                  showLoading = false;
                });
              },
              gestureNavigationEnabled: true,
            ),

            showLoading ? Center(child: CircularProgressIndicator()) : Container()
          ],
        ),
      ),
    );
  }

  _exitWebView(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
    } else {
      Navigator.of(context).pop();
    }
  }
}