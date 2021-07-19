import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';

class InfoGraphicsServices {
  Future<void> shareInfoGraphics(title, images) async {
    try {
      final Map<String, Uint8List> files = Map<String, Uint8List>();
      var index = 0;
      for (String image in images) {
        var request = await HttpClient().getUrl(Uri.parse(image));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        files[StringUtils.replaceSymbolToUnderscore(
            index == 0 ? '$title.jpg' : '$title$index.jpg')] = bytes;
        index++;
      }

      await Share.files(Dictionary.appName, files, 'image/jpg',
          text: '$title\n\n${Dictionary.sharedFrom}');

      await AnalyticsHelper.setLogEvent(Analytics.tappedInfoGraphicsShare,
          <String, dynamic>{'title': title, 'image': images[0]});
    } catch (e) {
      print('error: $e');
    }
  }
}
