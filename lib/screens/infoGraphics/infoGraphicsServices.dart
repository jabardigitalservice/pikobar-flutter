import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';

class InfoGraphicsServices {
  Future<void> shareInfoGraphics(title, image) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(image));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file(Dictionary.appName, '$title.jpg', bytes, 'image/jpg',
          text: title);
    } catch (e) {
      print('error: $e');
    }
  }
}
