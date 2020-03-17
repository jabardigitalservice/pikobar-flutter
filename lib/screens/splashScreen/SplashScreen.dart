import 'package:flutter/material.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('${Environment.logoAssets}logo.png',
            width: 150.0, height: 150.0),
      ),
    );
  }
}
