import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class EmptyData extends StatelessWidget {
  final String message, desc;
  final bool center;
  final EdgeInsetsGeometry margin;
  final bool isFlare;
  final String image;

  /// * [message] type String must not be null.
  /// * [desc] type String.
  /// * [margin] type from class EdgeInsetsGeometry.
  /// * [isFlare] type bool default value is true.
  /// * [center] type bool default value is true.
  /// * [image] type String must not be null if [isFlare] is false.
  EmptyData(
      {this.message,
      this.desc,
      this.center = true,
      this.margin,
      this.isFlare = true,
      this.image});

  @override
  Widget build(BuildContext context) {
    if (center) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isFlare
                ? Container(
                    width: 200.0,
                    height: 200.0,
                    child: FlareActor(
                      '${Environment.flareAssets}empty_data.flr',
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: 'empty',
                    ),
                  )
                : Container(
                    width: 200.0,
                    height: 200.0,
                    child: Image.asset(image),
                  ),
            Text(message,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsFamily.lato,
                    fontSize: 15)),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding:EdgeInsets.only(left: 50, right: 50),
              child: Text(desc == null ? '' : desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 13,
                      color: ColorBase.darkGrey)),
            )
          ],
        ),
      );
    } else {
      return Container(
        alignment: Alignment.topCenter,
        margin: margin,
        child: Column(
          children: <Widget>[
            isFlare
                ? Container(
                    width: 200.0,
                    height: 200.0,
                    child: FlareActor(
                      '${Environment.flareAssets}empty_data.flr',
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: 'empty',
                    ),
                  )
                : Container(
                    width: 200.0,
                    height: 200.0,
                    child: Image.asset(image),
                  ),
            Text(message,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsFamily.lato,
                    fontSize: 14)),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(desc == null ? '' : desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: FontsFamily.lato, fontSize: 12)),
            )
          ],
        ),
      );
    }
  }
}
