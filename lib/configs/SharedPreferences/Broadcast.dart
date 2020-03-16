import 'package:shared_preferences/shared_preferences.dart';

class BroadcastSharedPreference {
  /// Method get
  static Future<int> getBroadcastPage() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt('broadcastPage');
  }

  /// Method set
  static Future<bool> setBroadcastPage(int value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setInt('broadcastPage', value);
  }
}
