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

  @override
  void initState() {
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
                  initialUrl: widget.url,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: true,
                        useShouldOverrideUrlLoading: true,
                      ),
                      android: AndroidInAppWebViewOptions()),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
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
