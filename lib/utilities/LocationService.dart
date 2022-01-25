import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/locationPermission/location_permission_bloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/screens/onBoarding/OnboardingScreen.dart';

import 'AnalyticsHelper.dart';

class LocationService {
  static Future<bool> initializeBackgroundLocation(BuildContext context) async {
    final locationBloc = BlocProvider.of<LocationPermissionBloc>(context);

    bool isGranted = await Permission.locationAlways.status.isGranted ||
        await Permission.locationWhenInUse.status.isGranted;
    if (isGranted) {
      locationBloc
        ..add(LocationPermissionLoad(isGranted))
        ..close();
    } else {
      isGranted = await _buildPermissionWidget(context, locationBloc);
    }

    return isGranted;
  }

  static Future<bool> _buildPermissionWidget(
      BuildContext context, LocationPermissionBloc locationBloc) async {
    bool isGranted;

    final result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()))
        as Map<Permission, PermissionStatus>;

    if (result != null) {
      isGranted = result[Permission.locationAlways].isGranted ||
          result[Permission.locationWhenInUse].isGranted;
      locationBloc.add(LocationPermissionLoad(isGranted));
      if (isGranted) {
        locationBloc.close();
      }

      _onStatusRequested(context, result);
    } else {
      isGranted = false;
      locationBloc.add(LocationPermissionLoad(isGranted));
    }

    return isGranted;
  }

  static Future<void> _onStatusRequested(
      BuildContext context, Map<Permission, PermissionStatus> statuses) async {
    if (statuses[Permission.locationAlways].isGranted ||
        statuses[Permission.locationAlways].isGranted) {
      AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }
}
