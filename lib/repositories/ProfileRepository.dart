import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/EndPointPath.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/constants/HttpHeaders.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pikobar_flutter/models/CityModel.dart';

class ProfileRepository {
  String status, verificationid;

  Future<void> sendCodeToPhoneNumber(
      String id,
      phoneNumber,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent) async {
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {};

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: Dictionary.inaCode + phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<void> linkCredential(
      String id,
      phoneNumber,
      gender,
      address,
      cityId,
      provinceId,
      name,
      nik,
      DateTime birthdate,
      AuthCredential credential,
      LatLng latLng) async {
    final User user = FirebaseAuth.instance.currentUser;
    List<UserInfo> providerList = user.providerData;
    if (providerList.length > 2) {
      await user.unlink(credential.providerId);
    }
    await user.linkWithCredential(credential);
    await saveToCollection(id, phoneNumber, gender, address, cityId, provinceId,
        name, nik, birthdate, latLng);
  }

  Future<void> saveToCollection(String id, phoneNumber, gender, address, cityId,
      provinceId, name, nik, DateTime birthdate, LatLng latLng) async {
    print(latLng);
    FirebaseFirestore.instance.collection(kUsers).doc(id).update({
      'phone_number': Dictionary.inaCode + phoneNumber,
      'gender': gender,
      'birthdate': birthdate,
      'address': address,
      'city_id': cityId,
      'province_id': provinceId,
      'name': name,
      'nik': nik,
      'location':
          latLng == null ? null : GeoPoint(latLng.latitude, latLng.longitude)
    });
  }

  Future<void> signInWithPhoneNumber(
      String smsCode,
      verificationID,
      id,
      phoneNumber,
      gender,
      address,
      cityId,
      provinceId,
      name,
      nik,
      DateTime birthdate,
      LatLng latLng) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID,
      smsCode: smsCode,
    );
    await linkCredential(id, phoneNumber, gender, address, cityId, provinceId,
        name, nik, birthdate, credential, latLng);
  }

  Future<CityModel> getCityList() async {
    await Future.delayed(Duration(seconds: 1));

    final response = await http
        .get('${EndPointPath.getCityList}/jabar?level=kabupaten',
            headers: await HttpHeaders.headers())
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      CityModel record = CityModel.fromJson(data);

      return record;
    } else if (response.statusCode == 401) {
      throw Exception(ErrorException.unauthorizedException);
    } else if (response.statusCode == 408) {
      throw Exception(ErrorException.timeoutException);
    } else {
      throw Exception(Dictionary.somethingWrong);
    }
  }

  Stream<DocumentSnapshot> getProfile(String uid) {
    return FirebaseFirestore.instance.collection(kUsers).doc(uid).snapshots();
  }
}
