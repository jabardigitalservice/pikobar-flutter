import 'package:shared_preferences/shared_preferences.dart';

class HistoryTabHomeSharedPreference {
  /// Method GET history tab home
  static Future<String> getHistoryTabHome() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('historytabhome');
  }

  /// Method SET history tab home
  static Future<bool> setHistoryTabHome(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('historytabhome', value);
  }
}