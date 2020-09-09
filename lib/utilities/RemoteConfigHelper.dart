import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'dart:convert';

class RemoteConfigHelper{
  /// Get the json decoded value from the remote config
  static Map<String, dynamic> decode({@required RemoteConfig remoteConfig, @required String firebaseConfig, @required String defaultValue}) {
    if (remoteConfig != null &&
       remoteConfig.getString(firebaseConfig) !=
            null ) {
      return json.decode(remoteConfig.getString(firebaseConfig));
    } else {
      return json.decode(defaultValue);
    }
  }
}

