import 'package:shared_preferences/shared_preferences.dart';

class LabelNewSharedPreference {
  /// Method GET label new
  static Future<String> getLabelNewInfoGraphics() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('labelnewinfographic');
  }

  /// Method SET label new
  static Future<bool> setLabelNewInfoGraphics(String value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString('labelnewinfographic', value);
  }
}
