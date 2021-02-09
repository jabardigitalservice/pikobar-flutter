import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/IsolationCenterModel.dart';
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

  const ReferralHospitalLoaded(this.referralHospitalList);

  @override
  List<Object> get props => [referralHospitalList];
}

class CallCenterLoaded extends EmergencyNumberState {
  final List<CallCenterModel> callCenterList;

  const CallCenterLoaded(this.callCenterList);

  @override
  List<Object> get props => [callCenterList];
}

class GugusTugasWebLoaded extends EmergencyNumberState {
  final List<GugusTugasWebModel> gugusTugasWebModel;

  const GugusTugasWebLoaded(this.gugusTugasWebModel);

  @override
  List<Object> get props => [gugusTugasWebModel];
}

class IsolationCenterLoaded extends EmergencyNumberState {
  final List<IsolationCenterModel> isolationCenterModel;

  const IsolationCenterLoaded(this.isolationCenterModel);

  @override
  List<Object> get props => [isolationCenterModel];
}
