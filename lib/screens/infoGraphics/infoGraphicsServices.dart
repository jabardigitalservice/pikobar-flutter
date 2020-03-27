import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:share/share.dart';

class InfoGraphicsServices {
  shareInfoGraphics(title, documentID) {
    final _backLink = '${UrlThirdParty.urlCoronaInfo}infographics/$documentID';

    Share.share(
        '$title\n\n${_backLink != null ? _backLink + '\n' : ''}\nBaca Selengkapnya di aplikasi Pikobar : ${UrlThirdParty.pathPlaystore}');
  }
}
