import 'dart:ui' show Color;

class ColorBase {
  static final blue = Color(0xFF00AADE);
  static final green = Color(0xFF009D57);
  static final grey = Color(0xFFFAFAFA);
  static final pink = Color(0xFFD71149);
  static final bubbleChatBlue = Color(0xFFD5E9F4);
  static final darkRed = Color(0xFFD23C3C);

  static final gradientBlue = [Color(0xFF00AADE), Color(0xFF0669B1)];
  static final gradientBlueToPurple = [Color(0xFF005C97), Color(0xFF363795)];
  static final gradientBlueOpacity = [
    Color(0xFF00AADE),
    Color(0xFF0669B1).withOpacity(0.8)
  ];
  static final gradientBlackOpacity = [
    Color(0xFF000000).withOpacity(0.1),
    Color(0xFF000000).withOpacity(0.7)
  ];

  static final yellow = Color(0xfffdcc3b);
  static final orange = Color(0xffe8b638);
}
