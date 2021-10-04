import 'dart:io';

import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:meta/meta.dart';

class OCRHelper {
  OCRHelper({@required this.image})
      : assert(image != null, 'Image file can\'t be null');

  final File image;

  Future<Extracted> get extract async {
    try {
      final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(image);
      final TextRecognizer textRecognizer =
          GoogleVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);

      return Extracted(visionText.text, visionText.blocks);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> get documentCheck async {
    final regex = RegExp(
        r'^((?=.*\brs\b)|(?=.*\bklinik\b)|(?=.*\blab\b)|(?=.*\blaboratorium\b))((?=.*\bpcr\b)|(?=.*\bswab\b)|(?=.*\bantigen\b))((?=.*\bcov\b)|(?=.*\bcovid\b)|(?=.*\bsars\b)).*$',
        multiLine: true,
        caseSensitive: false);
    final extracted = await extract;
    final text = extracted.text.replaceAll(RegExp(r'\r?\n|\r'), ' ');
    print(text);
    return regex.hasMatch(text);
  }
}

class Extracted {
  Extracted(this.text, this.blocks);
  final String text;
  final List<TextBlock> blocks;
}
