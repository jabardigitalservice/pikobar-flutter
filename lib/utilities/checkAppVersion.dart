// import 'dart:io';

// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:package_info/package_info.dart';
// import 'package:pikobar_flutter/components/DialogUpdateApp.dart';

// Future<bool> checkAppVersion() async {
//   final RemoteConfig remoteConfig = await RemoteConfig.instance;

//   bool isUpdate = false;

//   String appVersion;
//   await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//     appVersion = packageInfo.version;
//   });

//   if (Platform.isAndroid) {
//     await remoteConfig.fetch();
//     await remoteConfig.activateFetched();

//     print(remoteConfig.getString('force_update_current_version'));
//     print('versi device $appVersion');
//     if (appVersion != remoteConfig.getString('force_update_current_version')) {
//       // return DialogUpdateApp();
//       // print('tidak sama');
//       isUpdate = true;
//     }
//   }

//   return isUpdate;
// }
