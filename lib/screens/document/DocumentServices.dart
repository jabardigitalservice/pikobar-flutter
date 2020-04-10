import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class DocumentServices {
  Future<void> shareDocument(title, document) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(document));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file(Dictionary.appName, '$title.pdf', bytes, 'text/pdf',
          text: '${Dictionary.sharedFrom}');
      AnalyticsHelper.setLogEvent(
          Analytics.tappedShareDocuments, <String, dynamic>{'title': title});
    } catch (e) {
      print('error: $e');
    }
  }
}
