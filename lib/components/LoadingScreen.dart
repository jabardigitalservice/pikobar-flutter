import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBase.blue,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: FlareActor('${Environment.flareAssets}wave.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Aura"),
        ),
      ),
    );
  }
}
