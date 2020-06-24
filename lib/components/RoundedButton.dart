import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final double minWidth, height;
  final String title;
  final GestureTapCallback onPressed;
  final Color color;
  final BorderSide borderSide;
  final BorderRadiusGeometry borderRadius;
  final TextStyle textStyle;
  final double elevation;

  RoundedButton({Key key,
    @required this.title,
    @required this.onPressed,
    this.minWidth,
    this.height = 45.0,
    this.borderSide,
    this.borderRadius,
    this.color,
    this.textStyle,
    this.elevation
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth != null ? minWidth : MediaQuery
          .of(context)
          .size
          .width,
      height: height,
      child: RaisedButton(
          color: color,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            side: borderSide ?? BorderSide.none,
            borderRadius: borderRadius != null
                ? borderRadius
                : BorderRadius.circular(5.0),
          ),
          child: Text(title, style: textStyle),
          onPressed: onPressed),
    );
  }
}
