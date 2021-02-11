import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class RemoteConfigHelper {
  /// Get the json decoded value from the remote config
  static dynamic decode(
      {@required RemoteConfig remoteConfig,
      @required String firebaseConfig,
      @required String defaultValue}) {
    if (remoteConfig != null &&
        remoteConfig.getString(firebaseConfig) != null) {
      return json.decode(remoteConfig.getString(firebaseConfig));
    } else {
      return json.decode(defaultValue);
    }
  }

  static String getString(
      {@required RemoteConfig remoteConfig,
      @required String firebaseConfig,
      @required String defaultValue}) {
    assert(remoteConfig != null);

    return remoteConfig.getString(firebaseConfig) ?? defaultValue;
  }
}
