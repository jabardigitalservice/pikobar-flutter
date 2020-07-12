import 'package:flutter/services.dart';

class RegexInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegexInputFormatter._(this._regExp);

  factory RegexInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegexInputFormatter._(regex);
    } catch (e) {
      // Something not right with regex string.
      assert(false, e.toString());
      return null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}