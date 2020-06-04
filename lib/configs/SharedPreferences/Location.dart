import 'package:shared_preferences/shared_preferences.dart';

class LocationSharedPreference {
  /// Method GET Last Location Recording Time
  static Future<int> getLastLocationRecordingTime() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt('lastLocationRecordingTime');
  }

  /// Method SET Last Location Recording Time
  static Future<bool> setLastLocationRecordingTime(int value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setInt('lastLocationRecordingTime', value);
  }
}