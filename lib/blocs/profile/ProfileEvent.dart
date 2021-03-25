import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  ProfileEvent([List props = const <dynamic>[]]);
}

class Save extends ProfileEvent {
  final String id, phoneNumber, gender, address, cityId, provinceId, name, nik;
  final DateTime birthdate;
  final LatLng latLng;
  Save(
      {this.id,
      this.phoneNumber,
      this.gender,
      this.address,
      this.cityId,
      this.provinceId,
      this.name,
      this.nik,
      this.birthdate,
      this.latLng});
  @override
  String toString() => 'Save';

  @override
  List<Object> get props => [
        id,
        phoneNumber,
        gender,
        address,
        cityId,
        provinceId,
        name,
        nik,
        birthdate,
        latLng
      ];
}

class Verify extends ProfileEvent {
  final String id, phoneNumber;
  final PhoneVerificationCompleted verificationCompleted;
  final PhoneVerificationFailed verificationFailed;
  final PhoneCodeSent codeSent;

  Verify(
      {this.id,
      this.phoneNumber,
      this.verificationCompleted,
      this.verificationFailed,
      this.codeSent});
  @override
  String toString() => 'Verify';

  @override
  List<Object> get props =>
      [id, phoneNumber, verificationCompleted, verificationFailed, codeSent];
}

class ConfirmOTP extends ProfileEvent {
  final String smsCode,
      verificationID,
      id,
      phoneNumber,
      gender,
      address,
      cityId,
      provinceId,
      name,
      nik;
  final DateTime birthdate;
  final LatLng latLng;
  ConfirmOTP(
      {this.smsCode,
      this.verificationID,
      this.id,
      this.phoneNumber,
      this.gender,
      this.address,
      this.cityId,
      this.provinceId,
      this.name,
      this.nik,
      this.birthdate,
      this.latLng});
  @override
  String toString() => 'ConfirmOTP';

  @override
  List<Object> get props => [
        smsCode,
        verificationID,
        id,
        phoneNumber,
        gender,
        address,
        cityId,
        provinceId,
        name,
        nik,
        birthdate,
        latLng
      ];
}

class VerifyConfirm extends ProfileEvent {
  @override
  String toString() => 'VerifyConfirm';

  @override
  List<Object> get props => [];
}

class VerifyFailed extends ProfileEvent {
  @override
  String toString() => 'VerifyFailed';

  @override
  List<Object> get props => [];
}

class CodeSend extends ProfileEvent {
  final String verificationID;
  CodeSend({this.verificationID});
  @override
  String toString() => 'CodeSend';

  @override
  List<Object> get props => [verificationID];
}

class CityLoad extends ProfileEvent {
  @override
  String toString() => 'CityLoad';

  @override
  List<Object> get props => [];
}

class ProfileLoad extends ProfileEvent {
  final String uid;
  ProfileLoad({@required this.uid});
  @override
  String toString() => 'ProfileLoad';

  @override
  List<Object> get props => [uid];
}

class ProfileUpdated extends ProfileEvent {
  final DocumentSnapshot profile;

   ProfileUpdated(this.profile);

  @override
  List<Object> get props => [profile];
}
