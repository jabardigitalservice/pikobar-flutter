import 'package:shared_preferences/shared_preferences.dart';

class ProfileUidSharedPreference {
  /// Method GET id profile
  static Future<String> getProfileUid() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('profileuid');
  }

  /// Method SET id profile
  static Future<bool> setProfileUid(String value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString('profileuid', value);
  }
}