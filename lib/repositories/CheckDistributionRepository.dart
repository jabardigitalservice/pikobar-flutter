import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/EndPointPath.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/constants/HttpHeaders.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';

class CheckDistributionReposity {
  Future<CheckDistributionModel> fetchRecord(lat, long) async {
    await Future.delayed(Duration(seconds: 1));

    final response = await http
        .get('${EndPointPath.checkDistribution}?long=$long&lat=$lat',
            headers: await HttpHeaders.headers())
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      CheckDistributionModel record = CheckDistributionModel.fromJson(data);

      return record;
    } else if (response.statusCode == 401) {
      throw Exception(ErrorException.unauthorizedException);
    } else if (response.statusCode == 408) {
      throw Exception(ErrorException.timeoutException);
    } else {
      throw Exception(Dictionary.somethingWrong);
    }
  }

  Future<void> saveToCollection(String id,lat,long) async {
    Firestore.instance
        .collection(Collections.users)
        .document(id)
        .updateData({'location': GeoPoint(lat, long)});
  }
}
