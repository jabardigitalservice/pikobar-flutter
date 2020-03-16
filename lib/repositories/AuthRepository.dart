// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:meta/meta.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:sapawarga/constants/EndPointPath.dart';
// import 'package:sapawarga/constants/ErrorException.dart';
// import 'package:sapawarga/constants/HttpHeaders.dart';
// import 'package:sapawarga/exceptions/ValidationException.dart';
// import 'package:sapawarga/repositories/AuthProfileRepository.dart';
// import 'package:sapawarga/repositories/BroadcastRepository.dart';
// import 'package:sapawarga/repositories/NotificationRepository.dart';
// import 'package:sapawarga/repositories/VideoRepository.dart';
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthRepository {
//   Future<String> authenticate({
//     @required String username,
//     @required String password,
//     String fcmToken,
//   }) async {
//     await Future.delayed(Duration(seconds: 1));

//     Map requestData = {
//       'LoginForm': {'username': username, 'password': password, 'push_token': fcmToken}
//     };

//     var requestBody = json.encode(requestData);

//     var response = await http
//         .post('${EndPointPath.login}',
//             headers: await HttpHeaders.headers(), body: requestBody)
//         .timeout(Duration(seconds: 10));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = json.decode(response.body);

//       await AnalyticsHelper.setLogEvent(Analytics.EVENT_SUCCESS_LOGIN, <String, dynamic>{
//         'username': username
//       });

//       return responseData['data']['access_token'];
//     }

//     if (response.statusCode == 422) {
//       Map<String, dynamic> responseData = json.decode(response.body);

//       throw ValidationException(responseData['data']);
//     }

//     throw Exception(ErrorException.loginException);
//   }

//   Future<void> unAuthenticate() async {
//     await Future.delayed(Duration(seconds: 1));

//     String token = await AuthRepository().getToken();

//     try {
//       var response =  await http.post(
//         '${EndPointPath.logout}',
//         headers: await HttpHeaders.headers(token: token),
//       ).timeout(Duration(seconds: 10));

//       print(response.body.toString());
//     } catch (e) {
//       print(e.toString());
//     }

//     await deleteToken();
//     await AuthProfileRepository().deleteLocalUserInfo();
//     await VideoRepository().deleteVideosKokabLocal();
//     await VideoRepository().deleteVideosJabarLocal();
//     await BroadcastRepository().clearLocalData();
//     await NotificationRepository().clearLocalData();
//   }

//   Future<void> deleteToken() async {
//     /// delete from keystore/keychain
//     await Future.delayed(Duration(seconds: 1));

//     final prefs = await SharedPreferences.getInstance();

//     await prefs.remove('token');
//     return;
//   }

//   Future<void> persistToken(String token) async {
//     // obtain shared preferences
//     final prefs = await SharedPreferences.getInstance();

//     // set value
//     await prefs.setString('token', token);

//     return;
//   }

//   Future<bool> hasToken() async {
//     /// read from keystore/keychain

//     final prefs = await SharedPreferences.getInstance();

//     return prefs.getString('token') == null ? false : true;
//   }

//   Future<String> getToken() async {
//     final prefs = await SharedPreferences.getInstance();

//     return prefs.getString('token');
//   }

//   Future<bool> requestResetPassword({@required String email}) async {
//     await Future.delayed(Duration(seconds: 1));

//     Map requestData = {
//       'email': email
//     };

//     var requestBody = json.encode(requestData);

//     var response = await http
//         .post('${EndPointPath.requestResetPassword}',
//             headers: await HttpHeaders.headers(), body: requestBody)
//         .timeout(Duration(seconds: 10));

//     if (response.statusCode == 200) {
//       return true;
//     }

//     if (response.statusCode == 422) {
//       Map<String, dynamic> responseData = json.decode(response.body);

//       throw ValidationException(responseData['data']);
//     }

//     throw Exception(ErrorException.ioException);
//   }

//   Future<bool> setOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();

//     return prefs.setBool('onBoarding', true);
//   }

//   Future<bool> hasOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();

//     return prefs.getBool('onBoarding') ?? false;
//   }
// }
