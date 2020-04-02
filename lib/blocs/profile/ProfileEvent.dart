import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  ProfileEvent([List props = const <dynamic>[]]);
}

class Save extends ProfileEvent {
  final String id, phoneNumber;
  Save({this.id, this.phoneNumber});
  @override
  String toString() => 'Save';

  @override
  List<Object> get props => [id, phoneNumber];
}

class Verify extends ProfileEvent {
  final String id, phoneNumber;
  Verify({this.id, this.phoneNumber});
  @override
  String toString() => 'Verify';

  @override
  List<Object> get props => [id, phoneNumber];
}

class ConfirmOTP extends ProfileEvent {
   final String smsCode,verificationID,id, phoneNumber;
  ConfirmOTP({this.smsCode,this.verificationID, this.id, this.phoneNumber});
  @override
  String toString() => 'ConfirmOTP';

  @override
  List<Object> get props => [smsCode,verificationID,id,phoneNumber];
}
