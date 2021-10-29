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
    RegExp formatValidation = RegExp(
        r"^(1[1-9]|21|[37][1-6]|5[1-3]|6[1-5]|[89][12])\d{2}\d{2}([04][1-9]|[1256][0-9]|[37][01])(0[1-9]|1[0-2])\d{2}(?!0000)\d{4}$");

    if (val.isEmpty) return Dictionary.errorEmptyNIK;

    if (val.length > 16) return Dictionary.errorMaximumNIK;

    if (val.length < 16) return Dictionary.errorMinimumNIK;

    if (!formatValidation.hasMatch(val)) return Dictionary.errorNotValidNIK;

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

  static String npsValidation(String val) {
    if (val.length < 6) return Dictionary.errorMinimumEmptyNPS;

    if (val.isEmpty) return Dictionary.errorEmptyNPS;

    return null;
  }

  static bool checkSwabDocument(String val) {
    if (val == null) {
      return null;
    }
    final regex = RegExp(
        r'^((?=.*\brs\b)|(?=.*\bklinik\b)|(?=.*\blab\b)|(?=.*\blaboratorium\b))((?=.*\bpcr\b)|(?=.*\bswab\b)|(?=.*\bantigen\b))((?=.*\bcov\b)|(?=.*\bcovid\b)|(?=.*\bsars\b)).*$',
        multiLine: true,
        caseSensitive: false);
    final text = val.replaceAll(RegExp(r'\r?\n|\r'), ' ');
    return regex.hasMatch(text);
  }
}
