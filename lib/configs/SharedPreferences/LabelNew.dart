import 'package:shared_preferences/shared_preferences.dart';

class LabelNewSharedPreference {
  /// Method GET label new
  static Future<String> getLabelNew(String nameLabel) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(nameLabel);
  }

  /// Method SET label new
  static Future<bool> setLabelNew(String value, String nameLabel) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(nameLabel, value);
  }
}
