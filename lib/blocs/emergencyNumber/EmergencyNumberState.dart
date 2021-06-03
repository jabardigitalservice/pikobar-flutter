import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/IsolationCenterModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';

abstract class EmergencyNumberState extends Equatable {
  const EmergencyNumberState();

  @override
  List<Object> get props => <Object>[];
}

class InitialEmergencyNumberState extends EmergencyNumberState {}

class EmergencyNumberLoading extends EmergencyNumberState {}

class ReferralHospitalLoaded extends EmergencyNumberState {
  final List<ReferralHospitalModel> referralHospitalList;

  const ReferralHospitalLoaded(this.referralHospitalList);

  @override
  List<Object> get props => <Object>[referralHospitalList];
}

class CallCenterLoaded extends EmergencyNumberState {
  final List<CallCenterModel> callCenterList;

  const CallCenterLoaded(this.callCenterList);

  @override
  List<Object> get props => <Object>[callCenterList];
}

class GugusTugasWebLoaded extends EmergencyNumberState {
  final List<GugusTugasWebModel> gugusTugasWebModel;

  const GugusTugasWebLoaded(this.gugusTugasWebModel);

  @override
  List<Object> get props => <Object>[gugusTugasWebModel];
}

class IsolationCenterLoaded extends EmergencyNumberState {
  final List<IsolationCenterModel> isolationCenterModel;

  const IsolationCenterLoaded(this.isolationCenterModel);

  @override
  List<Object> get props => <Object>[isolationCenterModel];
}
