import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/constants/collections.dart';

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

Future<void> initializePlatformState() async {
  Map<String, dynamic> deviceData;
  User _user = FirebaseAuth.instance.currentUser;
  PackageInfo _packageInfo = await PackageInfo.fromPlatform();

  if (_user != null) {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo _deviceInfo = await deviceInfoPlugin.androidInfo;
        deviceData = _readAndroidBuildData(_deviceInfo, _packageInfo);
        _sendDataToFirestore(
            _user,
            '${_deviceInfo.model ?? (_deviceInfo.manufacturer + _deviceInfo.product) ?? _deviceInfo.androidId}',
            deviceData);
      } else if (Platform.isIOS) {
        IosDeviceInfo _deviceInfo = await deviceInfoPlugin.iosInfo;
        deviceData =
            _readIosDeviceInfo(_deviceInfo, await PackageInfo.fromPlatform());
        _sendDataToFirestore(
            _user,
            '${_deviceInfo.model + ' ' + _deviceInfo.identifierForVendor.split('-')[0]}',
            deviceData);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }
}

Map<String, dynamic> _readAndroidBuildData(
    AndroidDeviceInfo build, PackageInfo packageInfo) {
  return <String, dynamic>{
    'buildNumber': packageInfo.buildNumber,
    'version.app': packageInfo.version,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'brand': build.brand,
    'device': build.device,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'hardware': build.hardware,
    'supportedAbis': build.supportedAbis,
    'isPhysicalDevice': build.isPhysicalDevice,
    'created_at': DateTime.now()
  };
}

Map<String, dynamic> _readIosDeviceInfo(
    IosDeviceInfo data, PackageInfo packageInfo) {
  return <String, dynamic>{
    'buildNumber': packageInfo.buildNumber,
    'version.app': packageInfo.version,
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'created_at': DateTime.now()
  };
}

Future<void> _sendDataToFirestore(
    User user, String deviceId, Map<String, dynamic> data) async {
  if (user != null) {
    final userDocument =
        FirebaseFirestore.instance.collection(kUsers).doc(user.uid);

    final devicesDocument = userDocument.collection(kUserDevices).doc(deviceId);

    await devicesDocument.get().then((snapshot) async {
      if (!snapshot.exists) {
        await devicesDocument.set(data);
      }
    });

    await userDocument.get().then((snapshot) async {
      if (snapshot.exists) {
        await userDocument
            .update({'last_open_at': DateTime.now()}).catchError((onError) {
          print("Update last_open failed : ${onError.toString()}");
        });
      }
    });
  }
}
