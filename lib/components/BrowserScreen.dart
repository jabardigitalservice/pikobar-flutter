import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pedantic/pedantic.dart';

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
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                          applicationNameForUserAgent: 'PIKOBAR',
                          useShouldOverrideUrlLoading: true,
                          mediaPlaybackRequiresUserGesture: false,
                          javaScriptEnabled: true,
                          javaScriptCanOpenWindowsAutomatically: true,
                          userAgent:
                              "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"),
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
                    setState(() {
                      url = createWindowRequest.url;
                      webView.loadUrl(url: url);
                    });
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
    if (await webView.canGoBack()) {
      unawaited(webView.goBack());
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
