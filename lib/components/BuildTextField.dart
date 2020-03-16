import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final validation;
  final TextInputType textInputType;
  final TextStyle textStyle;
  final bool isEdit;


  /// @params
  /// * [title] type String must not be null.
  /// * [hintText] type String must not be null.
  /// * [controller] type from class TextEditingController must not be null.
  /// * [validation] type from class Validation.
  /// * [textInputType] type from class TextInputType.
  /// * [textStyle] type from class TextStyle.
  /// * [isEdit] type bool.
  BuildTextField(
      {this.title,
      this.hintText,
      this.controller,
      this.validation,
      this.textInputType,
      this.textStyle,
      this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
          ),
          TextFormField(
            style: textStyle != null
                ? textStyle
                : TextStyle(color: Colors.black),
            enabled: isEdit != null ? false : true,
            validator: validation,
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
            keyboardType:
                textInputType != null ? textInputType : TextInputType.text,
          )
        ],
      ),
    );
  }
}
