import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

/// Shows a success modal material design bottom sheet.
void showSuccessBottomSheet(
    {@required BuildContext context,
    @required GestureTapCallback onPressed,
    Widget image,
    String title,
    String message,
    String buttonText,
    bool isDismissible = true}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      isDismissible: isDismissible,
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(Dimens.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /// Image section
              ///
              /// If image null, by default it will use image:
              /// ```
              /// Image.asset(
              ///    '${Environment.imageAssets}daily_success.png',
              ///    fit: BoxFit.fitWidth,
              /// )
              /// ```
              Container(
                padding: EdgeInsets.symmetric(horizontal: 44.0),
                margin: EdgeInsets.only(bottom: 24.0),
                child: image ??
                    Image.asset(
                      '${Environment.imageAssets}daily_success.png',
                      fit: BoxFit.fitWidth,
                    ),
              ),

              /// Title section
              ///
              /// If title null, by default it will use [Dictionary.savedSuccessfully]
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  title ?? Dictionary.savedSuccessfully,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
              ),

              /// Message section
              ///
              /// If message null, by default it will use [Dictionary.dailySuccess]
              Text(
                message ?? Dictionary.dailySuccess,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 12.0,
                    color: Colors.grey[600]),
              ),
              SizedBox(height: 24.0),

              /// Button section
              ///
              /// If title null, by default it will use [Dictionary.ok]
              /// Converts all characters in this title to upper case
              RoundedButton(
                  title:
                      buttonText ?? Dictionary.ok.toUpperCase(),
                  textStyle: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  color: ColorBase.green,
                  elevation: 0.0,
                  onPressed: onPressed)
            ],
          ),
        );
      });
}
