import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';

abstract class EmergencyNumberState extends Equatable {
  const EmergencyNumberState([List props = const <dynamic>[]]);
}

class InitialEmergencyNumberState extends EmergencyNumberState {
  @override
  List<Object> get props => [];
}

class EmergencyNumberLoading extends EmergencyNumberState {
  @override
  List<Object> get props => [];
}

class ReferralHospitalLoaded extends EmergencyNumberState {
  final List<ReferralHospitalModel> referralHospitalList;

  ReferralHospitalLoaded(this.referralHospitalList);

  @override
  List<Object> get props => [referralHospitalList];
}

class CallCenterLoaded extends EmergencyNumberState {
  final List<CallCenterModel> callCenterList;

  CallCenterLoaded(this.callCenterList);

  @override
  List<Object> get props => [callCenterList];
}

class GugusTugasWebLoaded extends EmergencyNumberState {
  final List<GugusTugasWebModel> gugusTugasWebModel;

  GugusTugasWebLoaded(this.gugusTugasWebModel);

  @override
  List<Object> get props => [gugusTugasWebModel];
}