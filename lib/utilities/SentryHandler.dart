import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryHandler {
  // List of ignored error strings.
  static List<String> _data = ['Future not completed'];

  // Check if the error thrown contains any of the strings
  // from the list of ignored error strings.
  static bool _ignore(dynamic error) {
    for (var item in _data) {
      if (error.toString().contains(item)) {
        return true;
      }
    }
    return false;
  }

  // Report the errors thrown to Sentry.io
  // except those that are ignored and not on release mode.
  static Future<void> reportError(dynamic error, {dynamic stackTrace}) async {
    if (_ignore(error)) {
      print('IGNORED ERROR: $error');
    } else {
      if (kReleaseMode) {
        await Sentry.captureException(error, stackTrace: stackTrace);
      } else {
        print('ERROR: $error');
      }
    }
  }
}
