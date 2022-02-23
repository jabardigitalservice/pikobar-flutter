import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:url_launcher/url_launcher.dart';

class BrowserScreen extends StatefulWidget {
  final String url;

  const BrowserScreen({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  double progress = 0.0;
  InAppWebViewController webView;
  String url;

  @override
  void initState() {
    url = widget.url;
    print(url);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _exitWebView,
      child: Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: Dictionary.appName,
          leading: Platform.isAndroid
              ? GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              : null,
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: progress < 1.0
                    ? const EdgeInsets.symmetric(vertical: 5.0)
                    : null,
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
            Expanded(
              child: Container(
                child: InAppWebView(
                  initialUrl: url,
                  shouldOverrideUrlLoading: (controller, request) async {
                    var url = request.url;
                    var uri = Uri.parse(url);

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );
                        // and cancel the request
                        return ShouldOverrideUrlLoadingAction.CANCEL;
                      }
                    }

                    return ShouldOverrideUrlLoadingAction.ALLOW;
                  },
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: true,
                        applicationNameForUserAgent: 'PIKOBAR',
                        javaScriptEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        useShouldOverrideUrlLoading: true,
                        userAgent: Platform.isAndroid
                            ? "Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.87 Mobile Safari/537.36"
                            : "Mozilla/5.0 (iPhone; CPU iPhone OS 15_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Mobile/15E148 Safari/604.1",
                      ),
                      android: AndroidInAppWebViewOptions(
                          allowContentAccess: true,
                          thirdPartyCookiesEnabled: true,
                          allowFileAccess: true,
                          supportMultipleWindows: true),
                      ios: IOSInAppWebViewOptions(
                        allowsInlineMediaPlayback: true,
                      )),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onCreateWindow: (controller, createWindowRequest) async {
                    if (createWindowRequest.url != null) {
                      setState(() {
                        url = createWindowRequest.url;
                        webView.loadUrl(url: url);
                      });
                    }
                    return false;
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitWebView() async {
    if (Platform.isAndroid && await webView.canGoBack()) {
      await webView.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
