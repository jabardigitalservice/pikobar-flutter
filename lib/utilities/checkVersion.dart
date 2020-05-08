import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/components/DialogUpdateApp.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';

checkForceUpdate(BuildContext context, RemoteConfig remoteConfig) async {
  String appVersion;
  await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });

  if (Platform.isAndroid) {
    bool forceUpdateRequired =
        remoteConfig.getString(FirebaseConfig.forceUpdateRequired) == 'false'
            ? false
            : true;
    String storeUrl = remoteConfig.getString(FirebaseConfig.storeUrl);
    String currentVersion =
        remoteConfig.getString(FirebaseConfig.currentVersion);
    
    if (forceUpdateRequired && extractNumber(appVersion) < extractNumber(currentVersion)) {
      showDialog(
          context: context,
          builder: (context) => WillPopScope(
              onWillPop: () {
                return;
              },
              child: DialogUpdateApp(
                linkUpdate: storeUrl,
              )),
          barrierDismissible: false);
    }
  }
}

Future<bool> checkVersion(RemoteConfig remoteConfig) async {
  String appVersion;
  await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });

  String currentVersion =
  remoteConfig.getString(FirebaseConfig.currentVersion);

  if (extractNumber(appVersion) < extractNumber(currentVersion)) {
    return true;
  } else {
    return false;
  }
}

int extractNumber(String version) {
  return int.parse(version.replaceAll(RegExp("\\D+"),""));
}
