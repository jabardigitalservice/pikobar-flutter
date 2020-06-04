import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/Location.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LocationModel.dart';
import 'package:pikobar_flutter/repositories/LocationsRepository.dart';

import 'AnalyticsHelper.dart';

class LocationService {
  static Future<void> sendCurrentLocation(BuildContext context) async {
    var permissionService =
        Platform.isIOS ? Permission.locationWhenInUse : Permission.location;

    if (await permissionService.status.isGranted) {
      await _actionSendLocation();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
                image: Image.asset(
                  '${Environment.iconAssets}map_pin.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionLocationGeneral,
                onOkPressed: () async {
                  Navigator.of(context).pop();
                  if (await permissionService.status.isDenied) {
                    await AppSettings.openLocationSettings();
                  } else {
                    permissionService.request().then((status) {
                      _onStatusRequested(context, status);
                    });
                  }
                },
                onCancelPressed: () {
                  AnalyticsHelper.setLogEvent(
                      Analytics.permissionDismissLocation);
                  Navigator.of(context).pop();
                },
              ));
    }
  }

  static Future<void> _actionSendLocation() async {
    int oldTime = await LocationSharedPreference.getLastLocationRecordingTime();

    if (oldTime == null) {
      oldTime = DateTime.now().millisecondsSinceEpoch;
      await LocationSharedPreference.setLastLocationRecordingTime(oldTime);
    }

    int minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(oldTime))
        .inMinutes;
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if (position != null && position.latitude != null) {
      if (minutes >= 5) {
        int currentMillis = DateTime.now().millisecondsSinceEpoch;

        LocationModel data = LocationModel(
          id: currentMillis.toString(),
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: currentMillis
        );

        await LocationsRepository().sendLocationToServer(data);

        await LocationSharedPreference.setLastLocationRecordingTime(
            currentMillis);
      }
    }
  }

  static Future<void> _onStatusRequested(
      BuildContext context, PermissionStatus statuses) async {
    if (statuses.isGranted) {
      await _actionSendLocation();
      AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }
}
