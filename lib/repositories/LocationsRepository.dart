import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/Location.dart';
import 'package:pikobar_flutter/constants/HttpHeaders.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/models/LocationModel.dart';
import 'package:http/http.dart' as http;

class LocationsRepository {
  Future<void> recordLocation(LocationModel data) async {
    User _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(data.latitude, data.longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        final fullAddress = pos.thoroughfare +
            ' ' +
            pos.subThoroughfare +
            ' ' +
            pos.subLocality +
            ', ' +
            pos.locality +
            ', ' +
            pos.subAdministrativeArea +
            ', ' +
            pos.administrativeArea +
            ' ' +
            pos.postalCode;

        Map parameterData = {
          "userId": _user.uid,
          "lat": data.latitude,
          "lon": data.longitude,
          "address": fullAddress,
          "province": pos.administrativeArea,
          "city": pos.subAdministrativeArea
        };

        var requestBody = json.encode(parameterData);

        final response = await http
            .patch('$kUrlTracking/user/location',
            headers: await HttpHeaders.headers(token: null),
            body: requestBody)
            .timeout(Duration(seconds: 10));

        print('[sendToGeocreate] status? ${response.statusCode}');
      }

      await LocationSharedPreference.setLastLocationRecordingTime(
          data.timestamp);
    }
  }
}
