import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:meta/meta.dart';

openChromeSafariBrowser({@required String url}) async {
  await ChromeSafariBrowser(bFallback: InAppBrowser()).open(
      url: url,
      options: ChromeSafariBrowserClassOptions(
          androidChromeCustomTabsOptions:
          AndroidChromeCustomTabsOptions(
              addShareButton: false,
              toolbarBackgroundColor: "#009D57",
              showTitle: false,
              enableUrlBarHiding: true
          ),
          iosSafariOptions: IosSafariOptions(
              barCollapsingEnabled: true)));
}