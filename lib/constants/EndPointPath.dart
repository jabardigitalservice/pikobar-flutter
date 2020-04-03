import 'package:pikobar_flutter/configs/FlavorConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class EndPointPath {
  // static String baseUrl = FlavorConfig.instance.values.baseUrl;
  // static String apiStorage = FlavorConfig.instance.values.apiStorage;
  // static String getVersion = apiStorage + '/version.json';
  // static String login = baseUrl + '/user/login';
  // static String logout = baseUrl + '/user/logout';
  // static String profile = baseUrl + '/user/me';
  static String checkDistribution = Environment.baseUrl + '/check-my-location';
}
