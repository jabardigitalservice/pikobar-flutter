import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
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
                  title: buttonText ?? Dictionary.ok.toUpperCase(),
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

void showTextBottomSheet(
    {@required BuildContext context, String title, @required String message}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(Dimens.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Divider section
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimens.padding),
                  height: 4,
                  width: 80.0,
                  decoration: BoxDecoration(
                      color: ColorBase.menuBorderColor,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),

              /// Title section
              ///
              /// If title null, the title section will be hidden
              title != null
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),

              /// Message section
              ///
              /// Message section is required, it can't be null
              Html(
                data: message,
                style: {
                  'body': Style(
                      margin: EdgeInsets.zero,
                      fontFamily: FontsFamily.lato,
                      fontSize: FontSize(12.0),
                      color: ColorBase.veryDarkGrey)
                },
              ),
              SizedBox(height: Dimens.sbHeight)
            ],
          ),
        );
      });
}

Future<void> showWidgetBottomSheet(
    {@required BuildContext context, Widget child, bool isScrollControlled = false}) async {
  return await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(Dimens.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Divider section
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimens.padding),
                  height: 4,
                  width: 80.0,
                  decoration: BoxDecoration(
                      color: ColorBase.menuBorderColor,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),

              /// Title section
              ///
              /// If title null, the title section will be hidden
              child ?? Container(),


              SizedBox(height: Dimens.sbHeight)
            ],
          ),
        );
      });
}
