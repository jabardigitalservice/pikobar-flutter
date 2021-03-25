import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class LabelNewScreen extends StatelessWidget {
  LabelNewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: ColorBase.red400,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Dimens.dialogRadius),
      ),
      child: Text(Dictionary.newLabel,
          style: TextStyle(
              color: Colors.white,
              fontFamily: FontsFamily.roboto,
              fontSize: 10.0,
              fontWeight: FontWeight.w600)),
    );
  }
}
