import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/EndPointPath.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/constants/HttpHeaders.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';

class BannerRepository {
  Future<List<BannerModel>> fetchRecords() async {
    await Future.delayed(Duration(seconds: 1));

    // String token = await AuthRepository().getToken();

    final response = await http
        .get('${EndPointPath.profile}?limit=5',
            headers: await HttpHeaders.headers())
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data']['items'];

      final list = listBannerFromJson(jsonEncode(data));

      return list;
    } else if (response.statusCode == 401) {
      throw Exception(ErrorException.unauthorizedException);
    } else if (response.statusCode == 408) {
      throw Exception(ErrorException.timeoutException);
    } else {
      throw Exception(Dictionary.somethingWrong);
    }
  }
}
