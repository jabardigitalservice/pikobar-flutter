import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => <Object>[];
}

class Save extends ProfileEvent {
  final String id, phoneNumber, gender, address, cityId, provinceId, name, nik;
  final DateTime birthdate;
  final LatLng latLng;

  const Save(
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
  List<Object> get props => <Object>[
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

  const Verify(
      {this.id,
      this.phoneNumber,
      this.verificationCompleted,
      this.verificationFailed,
      this.codeSent});

  @override
  List<Object> get props => <Object>[
        id,
        phoneNumber,
        verificationCompleted,
        verificationFailed,
        codeSent
      ];
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

  const ConfirmOTP(
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
  List<Object> get props => <Object>[
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

class VerifyConfirm extends ProfileEvent {}

class VerifyFailed extends ProfileEvent {}

class CodeSend extends ProfileEvent {
  final String verificationID;

  const CodeSend({this.verificationID});

  @override
  List<Object> get props => <Object>[verificationID];
}

class CityLoad extends ProfileEvent {}

class ProfileLoad extends ProfileEvent {
  final String uid;

  const ProfileLoad({@required this.uid});

  @override
  List<Object> get props => <Object>[uid];
}

class ProfileUpdated extends ProfileEvent {
  final DocumentSnapshot profile;

  const ProfileUpdated(this.profile);

  @override
  List<Object> get props => <Object>[profile];
}
