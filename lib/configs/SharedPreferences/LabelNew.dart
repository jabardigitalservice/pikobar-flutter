import 'package:shared_preferences/shared_preferences.dart';

class LabelNewSharedPreference {
  /// Method GET label new
  Future<String> getLabelNew(String nameLabel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(nameLabel);
  }

  /// Method SET label new
  Future<bool> setLabelNew(String value, String nameLabel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(nameLabel, value);
  }
}
