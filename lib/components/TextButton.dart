import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  final String title;
  final TextStyle textStyle;
  final GestureTapCallback onTap;
  final EdgeInsets padding;

  TextButton(
      {@required this.title,
      @required this.onTap,
      this.textStyle,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != null ? padding : EdgeInsets.all(0.0),
      child: GestureDetector(
        child: Text(
          title,
          style: textStyle,
        ),
        onTap: onTap,
      ),
    );
  }
}
