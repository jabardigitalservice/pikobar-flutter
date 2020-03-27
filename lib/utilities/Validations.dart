import 'package:pikobar_flutter/constants/Dictionary.dart';

class Validations {
  static String phoneValidation(String val) {
    Pattern pattern = r"^(^62\s?|^8)(\d{5,13})$";

    RegExp regex = RegExp(pattern);

    if (val.isEmpty) return Dictionary.errorEmptyPhone;

    if (val.length < 3) return Dictionary.errorMinimumPhone;

    if (val.length > 13) return Dictionary.errorMaximumPhone;
    
    if (!regex.hasMatch(val)) return Dictionary.errorInvalidPhone;

    

    return null;
  }
}
