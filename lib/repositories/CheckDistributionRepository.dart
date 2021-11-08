import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/EndPointPath.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/constants/HttpHeaders.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';

class CheckDistributionRepository {
  Future<CheckDistributionModel> fetchRecord(
      {lat, long, cityId, subCityId, isOther = false}) async {
    String param;
    if (isOther) {
      param = '?bps_kecamatan=$subCityId&bps_kabupaten=$cityId';
    } else {
      param = '?lat=$lat&long=$long';
    }
    final response = await http
        .get('${EndPointPath.checkDistribution}$param',
            headers: await HttpHeaders.headers())
        .timeout(const Duration(seconds: 30));

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

  Future<void> saveToCollection(String id, lat, long) async {
    await FirebaseFirestore.instance
        .collection(kUsers)
        .doc(id)
        .update({'location': GeoPoint(lat, long)});
  }
}
