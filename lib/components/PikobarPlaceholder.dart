import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class PikobarPlaceholder extends StatelessWidget {
  const PikobarPlaceholder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('${Environment.logoAssets}logo.png',
              scale: 5.0),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text(
              'PIKOBAR',
              style: TextStyle(fontFamily: FontsFamily.intro, fontSize: 21.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}