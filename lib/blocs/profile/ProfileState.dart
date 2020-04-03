import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/UserModel.dart';

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
