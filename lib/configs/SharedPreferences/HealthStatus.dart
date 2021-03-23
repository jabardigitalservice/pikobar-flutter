import 'package:shared_preferences/shared_preferences.dart';

class HealthStatusSharedPreference {
  /// Method GET health status
  static Future<String> getHealthStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('healthstatus');
  }

  /// Method SET health status
  static Future<bool> setHealthStatus(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('healthstatus', value);
  }

  /// Method GET temp health status
  static Future<String> getTempHealthStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('temphealthstatus');
  }

  /// Method SET temp health status
  static Future<bool> setTempHealthStatus(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('temphealthstatus', value);
  }

  /// Method SET health status bool
  static Future<bool> setIsHealthStatusChange(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool('ishealthstatuschange', value);
  }

  /// Method GET health status bool
  static Future<bool> getIsHealthStatusChange() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('ishealthstatuschange');
  }
}
