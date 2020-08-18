import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'dart:convert';

class GetLabelRemoteConfig{
  static Map<String, dynamic> getLabel(RemoteConfig remoteConfig) {
    if (remoteConfig != null &&
       remoteConfig.getString(FirebaseConfig.labels) !=
            null ) {
      return json.decode(remoteConfig.getString(FirebaseConfig.labels));
    } else {
      return json.decode(FirebaseConfig.labelsDefaultValue);
    }
  }
}

