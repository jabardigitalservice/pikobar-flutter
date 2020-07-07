import 'package:flutter/material.dart';

/// A custom button is based on a [Material] widget.
///
/// * [color], the color of the button.
/// * [borderColor], the color of the side of the border button.
/// * [onPressed], called when the button is tapped or otherwise activated.
class CustomButton {

  /// Create a filled button from a pair of widgets that serve as the button's
  /// [icon] and [label].
  ///
  /// The icon and label are arranged in a row and padded by 10 logical pixels,
  /// with an 10 pixel gap in between.
  static RaisedButton icon({Color color,
    Color borderColor,
    @required Widget icon,
    @required Widget label,
    GestureTapCallback onPressed}) {
    return RaisedButton(
      splashColor: Colors.grey,
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor)),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[icon, SizedBox(width: 10.0), label],
        ),
      ),
      onPressed: onPressed,
    );
  }
}