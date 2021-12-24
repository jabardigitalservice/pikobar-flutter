import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/CityModel.dart';

@immutable
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => <Object>[];
}

class ProfileUninitialized extends ProfileState {}

class ProfileSaved extends ProfileState {}

class ProfileVerified extends ProfileState {}

class ProfileWaiting extends ProfileState {}

class ProfileOTPSent extends ProfileState {
  final String? verificationID;

  const ProfileOTPSent({this.verificationID});

  @override
  List<Object> get props => <Object>[verificationID!];
}

class ProfileVerifiedFailed extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final DocumentSnapshot? profile;

  const ProfileLoaded({this.profile});

  @override
  List<Object> get props => <Object>[profile!];
}

class ProfileLoading extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String? error;

  const ProfileFailure({@required this.error});

  @override
  String toString() => 'Profile { error: $error }';

  @override
  List<Object> get props => <Object>[error!];
}

class CityLoading extends ProfileState {}

class CityLoaded extends ProfileState {
  final CityModel? record;

  const CityLoaded({@required this.record});

  @override
  List<Object> get props => <Object>[record!];
}
