import 'package:package_info/package_info.dart';

import 'Dictionary.dart';

class HttpHeaders {
  static Future<Map<String, String>> headers({String token}) async {
    String version = Dictionary.version;
    String packageName;

    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      packageName = packageInfo.packageName;
    });

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': packageName,
      'X-Requested-With-Version': version,
      'Authorization':
          'Bearer ${token != null && token.isNotEmpty ? token : ''}',
    };
  }
}
