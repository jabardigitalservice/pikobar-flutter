import 'package:pikobar_flutter/constants/Dictionary.dart';

class Validations {
  static String phoneValidation(String val) {
   
    if (val.isEmpty) return Dictionary.errorEmptyPhone;

    if (val.length < 3) return Dictionary.errorMinimumPhone;

    if (val.length > 13) return Dictionary.errorMaximumPhone;

    

    return null;
  }
}
