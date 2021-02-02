import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InWebView extends StatefulWidget {
  final String url;
  final String title;

  InWebView({@required this.url, this.title, Key key}) : super(key: key);

  @override
  _InWebViewState createState() => _InWebViewState();
}

class _InWebViewState extends State<InWebView> {
  WebViewController controllerGlobal;
  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitWebView(context),
      child: Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: widget.title != null && widget.title.isNotEmpty
              ? widget.title
              : Dictionary.appName,
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                controllerGlobal = webViewController;
              },
              onPageFinished: (url) {
                setState(() {
                  showLoading = false;
                });
              },
              gestureNavigationEnabled: true,
            ),
            showLoading
                ? Center(child: CircularProgressIndicator())
                : Container()
          ],
        ),
      ),
    );
  }

  Future<bool> _exitWebView(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
