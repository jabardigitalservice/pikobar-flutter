import 'package:pikobar_flutter/constants/Dictionary.dart';

class Validations {
  static String telephoneValidation(String val) {
    Pattern pattern = r"^(^0\s?|^8)(\d{5,13})$";

    RegExp regex = RegExp(pattern);

    if (val.isEmpty) return Dictionary.errorEmptyTelephone;

    if (val.length < 3) return Dictionary.errorMinimumTelephone;

    if (val.length > 13) return Dictionary.errorMaximumTelephone;

    if (!regex.hasMatch(val)) return Dictionary.errorInvalidTelephone;

    return null;
  }

  static String addressValidation(String val) {
    if (val.length > 255) return Dictionary.errorMaximumAddress;

    if (val.isEmpty) return Dictionary.errorEmptyAddress;

    return null;
  }

  static String nikValidation(String val) {
    if (val.length > 16) return Dictionary.errorMaximumNIK;

    if (val.length < 16) return Dictionary.errorMinimumNIK;

    if (val.isEmpty) return Dictionary.errorEmptyNIK;

    return null;
  }

  static String nameValidation(String val) {
    Pattern pattern = r"^([a-zA-Z `'.]*)$";
    RegExp regex = RegExp(pattern);

    if (val.isEmpty) return Dictionary.errorEmptyName;

    if (val.length < 4) return Dictionary.errorMinimumName;

    if (val.length > 30) return Dictionary.errorMaximumName;

    if (!regex.hasMatch(val)) return Dictionary.errorInvalidName;

    return null;
  }

  static String phoneValidation(String val) {
    Pattern pattern = r"^(^62\s?|^0)(\d{5,13})$";

    RegExp regex = RegExp(pattern);

    if (val.isEmpty) return Dictionary.errorEmptyPhone;

    if (val.length < 3) return Dictionary.errorMinimumPhone;

    if (val.length > 13) return Dictionary.errorMaximumPhone;

    if (!regex.hasMatch(val)) return Dictionary.errorInvalidPhone;

    return null;
  }

  static String otherRelationValidation(String val) {

    if (val.isEmpty) return Dictionary.errorEmptyOtherRelation;

    if (val.length < 3) return Dictionary.errorMinimumOtherRelation;

    if (val.length > 25) return Dictionary.errorMaximumOtherRelation;

    return null;
  }
}
