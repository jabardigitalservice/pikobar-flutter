
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/constants/Colors.dart';

import 'configs/Routes.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorBase.blue));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: '${Dictionary.appName}',
      theme: ThemeData(
          primaryColor: ColorBase.blue,
          primaryColorBrightness: Brightness.dark,
          fontFamily: FontsFamily.sourceSansPro),
      debugShowCheckedModeBanner: false,
      home: IndexScreen(),
      onGenerateRoute: generateRoutes,
      navigatorKey: NavigationConstrants.navKey,
    );
  }
}
