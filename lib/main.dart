import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/locationPermission/location_permission_bloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/utilities/SentryHandler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'configs/Routes.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    print(error);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  /// Wait for Sentry to initialize
  await SentryFlutter.init(
    (options) {
      /// If these values are not provided,
      /// the SDK will try to read them from the environment variable.
      /// (SENTRY_DSN, SENTRY_ENVIRONMENT, SENTRY_RELEASE)

      /*
      options.dsn = 'https://example@sentry.io/add-your-dsn-here';
      options.release = 'my-project-name@2.3.12';
      options.environment = 'staging';
      */
    },
  );

  runZonedGuarded(() {
    runApp(App());
  }, (error, stackTrace) async {
    print('runZonedGuarded: Caught error in my root zone.');
    await SentryHandler.reportError(error, stackTrace: stackTrace);
  });
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Future<void> _initializeFlutterFire() async {
    /// Wait for Firebase to initialize
    await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );

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
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
      home: FutureBuilder(
        future: _initializeFlutterFire(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }
              return BlocProvider<LocationPermissionBloc>(
                  create: (context) => LocationPermissionBloc(),
                  child: IndexScreen());
              break;
            default:
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        '${Environment.logoAssets}pikobar_big.png',
                        scale: 4.0,
                      ),
                      SizedBox(
                        height: Dimens.verticalPadding,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              );
          }
        },
      ),
      onGenerateRoute: generateRoutes,
      navigatorKey: NavigationConstrants.navKey,
    );
  }
}
