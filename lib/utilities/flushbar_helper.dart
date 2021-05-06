import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';

class FlushHelper {
  /// Get a loading notification flushbar
  static Flushbar loading() {
    return Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: false,
      blockBackgroundInteraction: true,
      routeBlur: 5.0,
      routeColor: Colors.grey[600].withOpacity(0.5),
      duration: Duration(seconds: 30),
      messageText: Container(
        child: Row(
          children: [
            Container(
              height: 28.0,
              width: 28.0,
              margin:
                  EdgeInsets.only(left: Dimens.padding, right: Dimens.padding),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(ColorBase.green),
              ),
            ),
            Text(
              'Mohon Tunggu...',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      leftBarIndicatorColor: ColorBase.green,
    );
  }
}
