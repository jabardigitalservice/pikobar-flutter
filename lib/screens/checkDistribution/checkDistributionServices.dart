import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class CheckDistributions {
    Future<void> handleLocation(BuildContext context) async {
    if (await Permission.location.status.isGranted) {

      Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      if (position != null && position.latitude != null) {
        List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
        // print(position.toString());
      if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      final stringAddress = pos.thoroughfare + ', ' + pos.locality +', ' + pos.subAdministrativeArea;
      print(stringAddress);
    }
        // Navigator.of(context).pushNamed(NavigationConstrants.Browser, arguments: '$url?lat=${position.latitude}&long=${position.longitude}');

      } else {
        // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        // Navigator.of(context).pushNamed(NavigationConstrants.Browser, arguments: '$url?lat=${position.latitude}&long=${position.longitude}');
      }

      // AnalyticsHelper.setLogEvent(Analytics.tappedSpreadCheck);

    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
            image: Image.asset(
              '${Environment.iconAssets}map_pin.png',
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            description: Dictionary.permissionLocationSpread,
            onOkPressed: () {
              Navigator.of(context).pop();
              Permission.location.request().then((status) {
                    _onStatusRequested(context, status);
              });
            },
            onCancelPressed: () {
              // AnalyticsHelper.setLogEvent(Analytics.permissionDismissLocation);
              Navigator.of(context).pop();
            },
          ));
    }
  }

  void _onStatusRequested(BuildContext context,
      PermissionStatus statuses) async {
    if (statuses.isGranted) {
      handleLocation(context);
      // AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      // AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }
}