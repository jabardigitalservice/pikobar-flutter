import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/EndPointPath.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/models/DailyChartModel.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';

class DailyChartRepository {
  Future<DailyChartModel> fetchRecord(kodeKab, apiKey) async {
    final dynamic response = await http.get(
        '${EndPointPath.dailyChart}?wilayah=kota&kode_kab=$kodeKab',
        headers: {'api-key': apiKey}).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);

      final DailyChartModel record = DailyChartModel.fromJson(data);

      return record;
    } else if (response.statusCode == 401) {
      throw Exception(ErrorException.unauthorizedException);
    } else if (response.statusCode == 408) {
      throw Exception(ErrorException.timeoutException);
    } else {
      throw Exception(Dictionary.somethingWrong);
    }
  }

  Future<String> getCityId(Position position, dynamic listCity) async {
    final LatLng latLng = LatLng(position.latitude, position.longitude);
    String city = await GeocoderRepository().getCity(latLng);
    dynamic tempCityId;
    String cityId;

    /// Checking city contains kab
    if (city.toLowerCase().contains('kab')) {
      /// Replace Kabupaten or Kabupatén to kab.

      city = city.replaceAll('Kabupaten', 'kab.');
      city = city.replaceAll('Kabupatén', 'kab.');
    }

    /// Checking city contains regency
    if (city.toLowerCase().contains('regency')) {
      /// Add kab. and delete Regency string.

      city = city.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      city = 'kab. ' + city.replaceAll('Regency', '');
    }

    for (var i = 0; i < listCity.length; i++) {
      /// Checking same name of [city] in [listCity]
      if (city.isNotEmpty &&
          listCity[i]['name'].toLowerCase().contains(city.toLowerCase())) {
        tempCityId = listCity[i];
      }
    }
    if (tempCityId != null) {
      cityId = tempCityId['code'];
    }
    return cityId;
  }
}
