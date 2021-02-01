import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:background_fetch/background_fetch.dart';

import 'configs/Routes.dart';

/// Receive events from BackgroundGeolocation in Headless state.
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  print('📬 --> $headlessEvent');

  switch (headlessEvent.name) {
    case bg.Event.TERMINATE:
      try {
        //bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        print('[getCurrentPosition] Headless: $headlessEvent');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }
      break;
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      print(location);
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      print(location);
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      print(geofenceEvent);
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      print(state);
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.HTTP:
      bg.HttpEvent response = headlessEvent.event;
      print(response);
      break;
    case bg.Event.POWERSAVECHANGE:
      bool enabled = headlessEvent.event;
      print(enabled);
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      bg.ConnectivityChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.ENABLEDCHANGE:
      bool enabled = headlessEvent.event;
      print(enabled);
      break;
    case bg.Event.AUTHORIZATION:
      bg.AuthorizationEvent event = headlessEvent.event;
      print(event);
      break;
  }
}

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  runZonedGuarded(() {
    runApp(App());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });

  /// Register BackgroundGeolocation headless-task.
  bg.BackgroundGeolocation.registerHeadlessTask(
      backgroundGeolocationHeadlessTask);

  /// Register to receive BackgroundFetch events after app is terminated.
  /// Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
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

    /// Else only enable it in non-debug builds.
    /// You could additionally extend this to allow users to opt-in.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);

    /// Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);

      /// Forward to original handler.
      originalOnError(errorDetails);
    };

    await Future.delayed(Duration(seconds: 1));
  }

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
