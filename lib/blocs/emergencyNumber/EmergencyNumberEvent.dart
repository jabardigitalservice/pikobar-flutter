import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/IsolationCenterModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';

abstract class EmergencyNumberEvent extends Equatable {
  const EmergencyNumberEvent([List props = const <dynamic>[]]);
}

class ReferralHospitalLoad extends EmergencyNumberEvent {
  @override
  String toString() => 'Event ReferralHospitalLoad';

  @override
  List<Object> get props => ["ReferralHospitalLoad"];
}

class ReferralHospitalUpdated extends EmergencyNumberEvent {
  final List<ReferralHospitalModel> referralModel;

  const ReferralHospitalUpdated(this.referralModel);

  @override
  List<Object> get props => [referralModel];
}

class CallCenterLoad extends EmergencyNumberEvent {
  @override
  String toString() => 'Event CallCenterLoad';

  @override
  List<Object> get props => ["CallCenterLoad"];
}

class CallCenterUpdated extends EmergencyNumberEvent {
  final List<CallCenterModel> callCenterModel;

  const CallCenterUpdated(this.callCenterModel);

  @override
  List<Object> get props => [callCenterModel];
}

class GugusTugasWebLoad extends EmergencyNumberEvent {
  @override
  String toString() => 'Event GugusTugasWebLoad';

  @override
  List<Object> get props => ["GugusTugasWebLoad"];
}

class GugusTugasWebUpdated extends EmergencyNumberEvent {
  final List<GugusTugasWebModel> gugusTugasWebModel;

  const GugusTugasWebUpdated(this.gugusTugasWebModel);

  @override
  List<Object> get props => [gugusTugasWebModel];
}

class IsolationCenterLoad extends EmergencyNumberEvent {
  @override
  String toString() => 'Event IsolationCenterLoad';

  @override
  List<Object> get props => ["IsolationCenterLoad"];
}

class IsolationCenterUpdated extends EmergencyNumberEvent {
  final List<IsolationCenterModel> isolationCenterModel;

  const IsolationCenterUpdated(this.isolationCenterModel);

  @override
  List<Object> get props => [isolationCenterModel];
}
