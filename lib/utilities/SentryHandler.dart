// import 'dart:io';

// import 'package:device_info/device_info.dart';
// import 'package:package_info/package_info.dart';
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/environment/Environment.dart';
// import 'package:sapawarga/models/UserInfoModel.dart';
// import 'package:sapawarga/repositories/AuthProfileRepository.dart';
// import 'package:sentry/sentry.dart';

// final SentryClient sentry = SentryClient(dsn: '${Environment.sentryDNS}');
// final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
// final AuthProfileRepository userRepository = AuthProfileRepository();

// Future<Event> getSentryEnvEvent(dynamic exception, dynamic stackTrace) async {

//   String versionText = Dictionary.version;

//   await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//       versionText = packageInfo.version != null
//           ? packageInfo.version
//           : Dictionary.version;
//   });

//   /// return Event with IOS extra information to send it to Sentry
//   if (Platform.isIOS) {
//     final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

//     return Event(
//       release: versionText,
//       environment: 'production', // replace it as it's desired
//       extra: <String, dynamic>{
//         'name': iosDeviceInfo.name,
//         'model': iosDeviceInfo.model,
//         'systemName': iosDeviceInfo.systemName,
//         'systemVersion': iosDeviceInfo.systemVersion,
//         'localizedModel': iosDeviceInfo.localizedModel,
//         'utsname': iosDeviceInfo.utsname.sysname,
//         'identifierForVendor': iosDeviceInfo.identifierForVendor,
//         'isPhysicalDevice': iosDeviceInfo.isPhysicalDevice,
//       },
//       exception: exception,
//       stackTrace: stackTrace,
//     );
//   }

//   /// return Event with Andriod extra information to send it to Sentry
//   if (Platform.isAndroid) {
//     final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

//     User userContext;
//     try {
//       final UserInfoModel userInfo = await userRepository.getUserInfo();
//       userContext = User(id: '${userInfo.id}', username: '${userInfo.username}', email: '${userInfo.email}', ipAddress: '127.0.0.1');
//     } catch (e) {
//       print('Failed to get user info');
//     }

//     return Event(
//       release: versionText,
//       environment: 'production', // replace it as it's desired
//       extra: <String, dynamic>{
//         'type': androidDeviceInfo.type,
//         'model': androidDeviceInfo.model,
//         'device': androidDeviceInfo.device,
//         'id': androidDeviceInfo.id,
//         'androidId': androidDeviceInfo.androidId,
//         'brand': androidDeviceInfo.brand,
//         'display': androidDeviceInfo.display,
//         'hardware': androidDeviceInfo.hardware,
//         'manufacturer': androidDeviceInfo.manufacturer,
//         'product': androidDeviceInfo.product,
//         'version': androidDeviceInfo.version.release,
//         'supported32BitAbis': androidDeviceInfo.supported32BitAbis,
//         'supported64BitAbis': androidDeviceInfo.supported64BitAbis,
//         'supportedAbis': androidDeviceInfo.supportedAbis,
//         'isPhysicalDevice': androidDeviceInfo.isPhysicalDevice,
//       },
//       exception: exception,
//       stackTrace: stackTrace,
//       userContext: userContext
//     );
//   }

//   /// Return standard Error in case of non-specifed paltform
//   ///
//   /// if there is no detected platform,
//   /// just return a normal event with no extra information
//   return Event(
//     release: versionText,
//     environment: 'production',
//     exception: exception,
//     stackTrace: stackTrace,
//   );
// }

// /// Whether the VM is running in debug mode.
// ///
// /// This is useful to decide whether a report should be sent to sentry.
// /// Usually reports from dev mode are not very
// /// useful, as these happen on developers' workspaces
// /// rather than on users' devices in production.
// bool get isInDebugMode {
//   bool inDebugMode = false;
//   assert(inDebugMode = true);
//   return inDebugMode;
// }

// /// Reports dart [error] along with its [stackTrace] to Sentry.io.
// Future<void> reportError(Object error, StackTrace stackTrace) async {
//   if (isInDebugMode) {
//     // In development mode, simply print to console.
//     // Print the full stacktrace in debug mode.
//     print(stackTrace);
//     return;
//   } else {
//     try {
//       // In production mode, report to the application zone to report to Sentry.
//       final Event event = await getSentryEnvEvent(error, stackTrace);
//       await sentry.capture(event: event);
//     } catch (e) {
//       print('Sending report to sentry.io failed: $e');
//       print('Original error: $error');
//     }
//   }
// }
