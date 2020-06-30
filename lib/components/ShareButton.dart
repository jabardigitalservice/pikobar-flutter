import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShareButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final double height;
  final double padding;
  final Alignment alignmentIcon;

  ShareButton({this.onPressed, this.height, this.padding, this.alignmentIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: IconButton(
        padding: EdgeInsets.all(padding),
        alignment: alignmentIcon != null ? alignmentIcon : Alignment.center,
        icon: Icon(FontAwesomeIcons.share, size: 17, color: Color(0xFF27AE60)),
        onPressed: onPressed,
      ),
    );
  }
}
