import 'package:flutter/material.dart';

ButtonTheme roundedButton(
    BuildContext context, String title, GestureTapCallback onPressed) {
  return ButtonTheme(
    minWidth: MediaQuery.of(context).size.width,
    height: 45.0,
    child: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)),
        child: Text(title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: onPressed),
  );
}
