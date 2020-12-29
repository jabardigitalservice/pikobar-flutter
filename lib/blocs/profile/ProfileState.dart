import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/CityModel.dart';

@immutable
abstract class ProfileState extends Equatable {
  ProfileState([List props = const <dynamic>[]]);
}

class ProfileUninitialized extends ProfileState {
  @override
  String toString() => 'ProfileUninitialized';

  @override
  List<Object> get props => [];
}

class ProfileSaved extends ProfileState {
  @override
  String toString() => 'ProfileSaved';

  @override
  List<Object> get props => [];
}

class ProfileVerified extends ProfileState {
  @override
  String toString() => 'ProfileVerified';

  @override
  List<Object> get props => [];
}

class ProfileWaiting extends ProfileState {
  @override
  String toString() => 'ProfileWaiting';

  @override
  List<Object> get props => [];
}

class ProfileOTPSent extends ProfileState {
  final String verificationID;
  ProfileOTPSent({this.verificationID});
  @override
  String toString() => 'ProfileOTPSent';

  @override
  List<Object> get props => [verificationID];
}

class ProfileVerifiedFailed extends ProfileState {
  @override
  String toString() => 'ProfileVerifiedFailed';

  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final DocumentSnapshot profile;
  ProfileLoaded(this.profile);
  @override
  String toString() => 'ProfileLoaded';

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  String toString() => 'ProfileLoading';

  @override
  List<Object> get props => [];
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'Profile { error: $error }';

  @override
  List<Object> get props => [error];
}

class CityLoading extends ProfileState {
  @override
  String toString() => 'CityLoading';

  @override
  List<Object> get props => [];
}

class CityLoaded extends ProfileState {
  final CityModel record;

  CityLoaded({@required this.record});

  @override
  List<Object> get props => [record];

  @override
  String toString() => 'CityLoaded { record: $record }';
}
