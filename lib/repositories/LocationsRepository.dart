import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/Location.dart';
import 'package:pikobar_flutter/constants/HttpHeaders.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/LocationModel.dart';
import 'package:http/http.dart' as http;

class LocationsRepository {
  Future<void> saveLocationToFirestore(LocationModel data) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    if (_user != null) {
      final userDocument =
          Firestore.instance.collection(kUsers).document(_user.uid);

      final locationsDocument =
          userDocument.collection(kUserLocations).document(data.id);

      locationsDocument.get().then((snapshot) {
        if (!snapshot.exists) {
          locationsDocument.setData({
            'id': data.id,
            'location': GeoPoint(data.latitude, data.longitude),
            'timestamp': DateTime.fromMillisecondsSinceEpoch(data.timestamp),
          });
        }
      });

      await sendLocationToGeocreate(_user.uid, data.latitude, data.longitude);

      await LocationSharedPreference.setLastLocationRecordingTime(
          data.timestamp);
    }
  }

  Future<void> sendLocationToGeocreate(
      String userId, double lat, double lon) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(lat, lon);

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
        "userId": userId,
        "lat": lat,
        "lon": lon,
        "address": fullAddress,
        "province": pos.administrativeArea,
        "city": pos.subAdministrativeArea
      };

      var requestBody = json.encode(parameterData);

      await http
          .patch('$kUrlTracking/user/location',
              headers: await HttpHeaders.headers(token: null),
              body: requestBody)
          .timeout(Duration(seconds: 10));
    }
  }
}
