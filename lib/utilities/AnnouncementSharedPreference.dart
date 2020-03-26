import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementSharedPreference {

  /// Method get
  static Future<bool> getAnnounceScreen() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool('announcement');
  }

  /// Method set
  static Future<bool> setAnnounceScreen(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setBool('announcement', value);
  }
}
