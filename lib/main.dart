import 'dart:async';

import 'package:device_preview/device_preview.dart' as devicePreview;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/constants/Colors.dart';

import 'configs/Routes.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  // Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runZoned<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // runApp(devicePreview.DevicePreview(
    //   enabled: !kReleaseMode, // disabled in release mode
    //   builder: (context) => App(),
    // ));

    runApp(App());
  }, onError: Crashlytics.instance.recordError);
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: '${Dictionary.appName}',
      theme: ThemeData(
          primaryColor: ColorBase.green,
          primaryColorBrightness: Brightness.light,
          fontFamily: FontsFamily.sourceSansPro),
      debugShowCheckedModeBanner: false,
      home: IndexScreen(),
      onGenerateRoute: generateRoutes,
      navigatorKey: NavigationConstrants.navKey,
    );
  }
}
