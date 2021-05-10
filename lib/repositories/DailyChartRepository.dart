import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/EndPointPath.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/models/DailyChartModel.dart';

class DailyChartRepository {
  Future<DailyChartModel> fetchRecord(kodeKab) async {
    final response = await http
        .get('${EndPointPath.dailyChart}?wilayah=kota&kode_kab=3273', headers: {
      'api-key': '480d0aeb78bd0064d45ef6b2254be9b3'
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      DailyChartModel record = DailyChartModel.fromJson(data);

      return record;
    } else if (response.statusCode == 401) {
      throw Exception(ErrorException.unauthorizedException);
    } else if (response.statusCode == 408) {
      throw Exception(ErrorException.timeoutException);
    } else {
      throw Exception(Dictionary.somethingWrong);
    }
  }
}
