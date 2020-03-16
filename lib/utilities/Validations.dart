import 'package:pikobar_flutter/constants/Dictionary.dart';

class Validations {
  static String usernameValidation(String val) {
    RegExp regex = RegExp(r'^[a-z0-9_./]+$');

    if (val.isEmpty) return Dictionary.errorEmptyUsername;

    if (val.length < 4) return Dictionary.errorMinimumUsername;

    if (val.length > 255) return Dictionary.errorMaximumUsername;

    if (!regex.hasMatch(val)) return Dictionary.errorInvalidUsername;

    return null;
  }

  static String passwordValidation(String val) {
    if (val.isEmpty) return Dictionary.errorEmptyPassword;

    return null;
  }

  static String confirmPasswordValidation(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return Dictionary.errorEmptyConfirmPassword;

    if (password != confirmPassword) return Dictionary.errorNotMatchPassword;

    return null;
  }

  static String emailValidation(String val) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]{3,}@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);

    if (val.isEmpty) return Dictionary.errorEmptyEmail;

    if (!regex.hasMatch(val)) return Dictionary.errorInvalidEmail;

    return null;
  }

  static String addressValidation(String val) {
    if (val.length > 255) return Dictionary.errorMaximumAddress;

    if (val.isEmpty) return Dictionary.errorEmptyAddress;

    return null;
  }

  static String nameValidation(String val) {
    Pattern pattern = r"^([a-zA-Z `'.]*)$";
    RegExp regex = RegExp(pattern);

    if (val.isEmpty) return Dictionary.errorEmptyName;

    if (val.length < 4) return Dictionary.errorMinimumName;

    if (val.length > 255) return Dictionary.errorMaximumName;

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

  static String commentValidation(String val) {
    if (val.isEmpty) return Dictionary.errorEmptyComment;

    if (val.length < 10) return Dictionary.errorMinimumComment;

    return null;
  }
}
