import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/IsolationCenterModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';

abstract class EmergencyNumberEvent extends Equatable {
  const EmergencyNumberEvent();

  @override
  List<Object> get props => <Object>[];
}

class ReferralHospitalLoad extends EmergencyNumberEvent {}

class ReferralHospitalUpdated extends EmergencyNumberEvent {
  final List<ReferralHospitalModel> referralModel;

  const ReferralHospitalUpdated(this.referralModel);

  @override
  List<Object> get props => <Object>[referralModel];
}

class CallCenterLoad extends EmergencyNumberEvent {}

class CallCenterUpdated extends EmergencyNumberEvent {
  final List<CallCenterModel> callCenterModel;

  const CallCenterUpdated(this.callCenterModel);

  @override
  List<Object> get props => <Object>[callCenterModel];
}

class GugusTugasWebLoad extends EmergencyNumberEvent {}

class GugusTugasWebUpdated extends EmergencyNumberEvent {
  final List<GugusTugasWebModel> gugusTugasWebModel;

  const GugusTugasWebUpdated(this.gugusTugasWebModel);

  @override
  List<Object> get props => <Object>[gugusTugasWebModel];
}

class IsolationCenterLoad extends EmergencyNumberEvent {}

class IsolationCenterUpdated extends EmergencyNumberEvent {
  final List<IsolationCenterModel> isolationCenterModel;

  const IsolationCenterUpdated(this.isolationCenterModel);

  @override
  List<Object> get props => <Object>[isolationCenterModel];
}
