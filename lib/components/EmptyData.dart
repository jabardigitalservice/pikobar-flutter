import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class EmptyData extends StatelessWidget {
  final String message;
  final bool center;
  final EdgeInsetsGeometry margin;

  EmptyData({this.message, this.center = true, this.margin});

  @override
  Widget build(BuildContext context) {
    if (center) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              child: FlareActor(
                '${Environment.flareAssets}empty_data.flr',
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: 'empty',
              ),
            ),
            Text(message,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
          ],
        ),
      );
    } else {
      return Container(
        alignment: Alignment.topCenter,
        margin: margin,
        child: Column(
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              child: FlareActor(
                '${Environment.flareAssets}empty_data.flr',
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: 'empty',
              ),
            ),
            Text(message,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
          ],
        ),
      );
    }
  }
}
