// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:meta/meta.dart';
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/constants/EndPointPath.dart';
// import 'package:sapawarga/constants/ErrorException.dart';
// import 'package:sapawarga/constants/HttpHeaders.dart';
// import 'package:sapawarga/exceptions/ValidationException.dart';
// import 'package:sapawarga/models/UserInfoModel.dart';
// import 'package:sapawarga/repositories/AuthRepository.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthProfileRepository {
//   Future<UserInfoModel> fetchUserInfo() async {
//     await Future.delayed(Duration(seconds: 1));

//     String token = await AuthRepository().getToken();

//     var response = await http.get(
//       '${EndPointPath.profile}',
//       headers: await HttpHeaders.headers(token: token),
//     );

//     Map userInfoMap = json.decode(response.body)['data'];

//     return UserInfoModel.fromJson(userInfoMap);
//   }

//   Future<void> persistUserInfo(UserInfoModel authUserInfo) async {
//     final prefs = await SharedPreferences.getInstance();

//     Map authUserInfoJson = authUserInfo.toJson();

//     await prefs.setString('auth_user_info', json.encode(authUserInfoJson));
//   }

//   Future<void> deleteLocalUserInfo() async {
//     await Future.delayed(Duration(seconds: 1));

//     final prefs = await SharedPreferences.getInstance();

//     await prefs.remove('auth_user_info');
//   }

//   Future<bool> hasLocalUserInfo() async {
//     final prefs = await SharedPreferences.getInstance();

//     return prefs.getString('auth_user_info') == null ? false : true;
//   }

//   Future<UserInfoModel> readLocalUserInfo() async {
//     final prefs = await SharedPreferences.getInstance();
//     String userInfoJsonString = prefs.getString('auth_user_info');

//     Map userInfoMap = json.decode(userInfoJsonString);

//     return UserInfoModel.fromJson(userInfoMap);
//   }

//   Future<UserInfoModel> getUserInfo({bool forceFetch = false}) async {
//     UserInfoModel authUserInfo;

//     bool hasUserInfo = await hasLocalUserInfo();

//     if (hasUserInfo == false || forceFetch == true) {
//       authUserInfo = await fetchUserInfo();
//       await persistUserInfo(authUserInfo);
//     } else {
//       authUserInfo = await readLocalUserInfo();
//     }

//     return authUserInfo;
//   }

//   Future<void> updateProfile(UserInfoModel userInfoModel) async {
//     String token = await AuthRepository().getToken();

//     UserInfoModel record = await getUserInfo();

//     UserInfoModel newRecord = UserInfoModel(
//       id: record.id,
//       roleLabel: record.roleLabel,
//       roleId: record.roleId,
//       kabkotaId: record.kabkotaId,
//       kabkota: record.kabkota,
//       kecId: record.kecId,
//       kecamatan: record.kecamatan,
//       kelId: record.kelId,
//       kelurahan: record.kelurahan,
//       rw: record.rw,
//       lat: userInfoModel.lat != null ? userInfoModel.lat : record.lat,
//       lon: userInfoModel.lon != null ? userInfoModel.lon : record.lon,
//       photoUrl: record.photoUrl != null
//           ? Uri.parse(record.photoUrl).path.replaceFirst('/', '')
//           : null,
//       username: userInfoModel.username,
//       name: userInfoModel.name,
//       email: userInfoModel.email,
//       rt: userInfoModel.rt,
//       address: userInfoModel.address,
//       phone: userInfoModel.phone,
//       facebook: userInfoModel.facebook,
//       instagram: userInfoModel.instagram,
//       twitter: userInfoModel.twitter,
//       educationLevelId: userInfoModel.educationLevelId != null
//           ? userInfoModel.educationLevelId
//           : record.educationLevelId,
//       jobTypeId: userInfoModel.jobTypeId != null
//           ? userInfoModel.jobTypeId
//           : record.jobTypeId,
//       birthDate: userInfoModel.birthDate != null
//           ? userInfoModel.birthDate
//           : record.birthDate,
//     );

//     Map data = {'UserEditForm': newRecord.toJson()};

//     String bodyData = jsonEncode(data);

//     var response = await http.post('${EndPointPath.profile}',
//         headers: await HttpHeaders.headers(token: token), body: bodyData);

//     if (response.statusCode == 200) {
//       final userRecord = await fetchUserInfo();
//       await persistUserInfo(userRecord);
//       return true;
//     } else if (response.statusCode == 401) {
//       throw Exception(ErrorException.unauthorizedException);
//     } else if (response.statusCode == 408) {
//       throw Exception(ErrorException.timeoutException);
//     } else if (response.statusCode == 422) {
//       Map<String, dynamic> responseData = json.decode(response.body);
//       throw ValidationException(responseData['data']);
//     } else {
//       throw Exception(Dictionary.somethingWrong);
//     }
//   }

//   Future updatePhoto(image, UserInfoModel authUserInfo) async {
//     AuthRepository authRepository = AuthRepository();

//     String token = await authRepository.getToken();

//     Uri uri = Uri.parse('${EndPointPath.profilePhotoUpdate}');
//     http.MultipartRequest request = http.MultipartRequest('POST', uri);

//     request.headers['Authorization'] = 'Bearer $token';

//     request.files.add(await http.MultipartFile.fromPath('image', image.path,
//         contentType: MediaType('image', 'jpeg')));

//     http.StreamedResponse response = await request.send();

//     String responseBody = await response.stream.transform(utf8.decoder).join();
//     Map<String, dynamic> data = jsonDecode(responseBody);

//     if (response.statusCode == 200) {
//       UserInfoModel newRecord = UserInfoModel(
//         id: authUserInfo.id,
//         roleLabel: authUserInfo.roleLabel,
//         roleId: authUserInfo.roleId,
//         kabkotaId: authUserInfo.kabkotaId,
//         kabkota: authUserInfo.kabkota,
//         kecId: authUserInfo.kecId,
//         kecamatan: authUserInfo.kecamatan,
//         kelId: authUserInfo.kelId,
//         kelurahan: authUserInfo.kelurahan,
//         rt: authUserInfo.rt,
//         lat: authUserInfo.lat,
//         lon: authUserInfo.lon,
//         photoUrl: data['data']['photo_url'],
//         username: authUserInfo.username,
//         name: authUserInfo.name,
//         email: authUserInfo.email,
//         rw: authUserInfo.rw,
//         address: authUserInfo.address,
//         phone: authUserInfo.phone,
//         facebook: authUserInfo.facebook,
//         instagram: authUserInfo.instagram,
//         twitter: authUserInfo.twitter,
//         educationLevelId: authUserInfo.educationLevelId,
//         educationLevel: authUserInfo.educationLevel,
//         jobTypeId: authUserInfo.jobTypeId,
//         jobType: authUserInfo.jobType,
//         birthDate: authUserInfo.birthDate,
//       );

//       await persistUserInfo(newRecord);

//       return data['data']['photo_url'];
//     } else if (response.statusCode == 401) {
//       throw Exception(ErrorException.unauthorizedException);
//     } else if (response.statusCode == 408) {
//       throw Exception(ErrorException.timeoutException);
//     } else if (response.statusCode == 422) {
//       Map<String, dynamic> responseData = json.decode(responseBody);
//       throw ValidationException(responseData['data']);
//     } else {
//       throw Exception(Dictionary.somethingWrong);
//     }
//   }

//   Future<bool> changePassword(
//       {@required String oldPass,
//       @required String newPass,
//       @required String confNewPass}) async {
//     String token = await AuthRepository().getToken();

//     await Future.delayed(Duration(seconds: 1));

//     Map requestData = {
//       'password_old': oldPass,
//       'password': newPass,
//       'password_confirmation': confNewPass
//     };

//     var requestBody = json.encode(requestData);

//     var response = await http
//         .post('${EndPointPath.changePassword}',
//             headers: await HttpHeaders.headers(token: token), body: requestBody)
//         .timeout(Duration(seconds: 10));
//     if (response.statusCode == 200) {
//       return true;
//     } else if (response.statusCode == 401) {
//       throw Exception(ErrorException.unauthorizedException);
//     } else if (response.statusCode == 408) {
//       throw Exception(ErrorException.timeoutException);
//     } else if (response.statusCode == 422) {
//       Map<String, dynamic> responseData = json.decode(response.body);
//       throw ValidationException(responseData['data']);
//     } else {
//       throw Exception(Dictionary.somethingWrong);
//     }
//   }

//   Future<bool> changeProfile(
//       {@required String name,
//       @required String email,
//       @required String phone,
//       @required String address,
//       String jobId,
//       String educationId}) async {
//     String token = await AuthRepository().getToken();

//     await Future.delayed(Duration(seconds: 1));

//     Map requestData = {
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'address': address,
//       'job_type_id': jobId == null || jobId == 'null' ? null : jobId,
//       'education_level_id': educationId == null || educationId == 'null' ? null : educationId
//     };

//     var requestBody = json.encode(requestData);

//     var response = await http
//         .post('${EndPointPath.changeProfile}',
//             headers: await HttpHeaders.headers(token: token), body: requestBody)
//         .timeout(Duration(seconds: 10));

//     if (response.statusCode == 200) {
//       return true;
//     } else if (response.statusCode == 401) {
//       throw Exception(ErrorException.unauthorizedException);
//     } else if (response.statusCode == 408) {
//       throw Exception(ErrorException.timeoutException);
//     } else if (response.statusCode == 422) {
//       Map<String, dynamic> responseData = json.decode(response.body);

//       throw ValidationException(responseData['data']);
//     } else {
//       throw Exception(Dictionary.somethingWrong);
//     }
//   }
// }
