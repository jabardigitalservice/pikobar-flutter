import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/constants/Colors.dart';

class ShareButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final double height;
  final double padding;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Alignment alignmentIcon;

  ShareButton(
      {this.onPressed,
      this.height,
      this.padding,
      this.paddingTop,
      this.paddingBottom,
      this.paddingRight,
      this.paddingLeft,
      this.alignmentIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: IconButton(
        padding: paddingRight != null ||
                paddingBottom != null ||
                paddingTop != null ||
                paddingLeft != null
            ? EdgeInsets.only(
                left: paddingLeft != null ? paddingLeft : 0,
                right: paddingRight != null ? paddingRight : 0,
                bottom: paddingBottom != null ? paddingBottom : 0,
                top: paddingTop != null ? paddingTop : 0)
            : EdgeInsets.all(padding != null ? padding : 10),
        alignment: alignmentIcon != null ? alignmentIcon : Alignment.center,
        icon: Icon(FontAwesomeIcons.shareAlt, size: 17, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
