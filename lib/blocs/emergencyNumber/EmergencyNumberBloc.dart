import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';
import 'package:pikobar_flutter/repositories/EmergencyNumberRepository.dart';
import 'Bloc.dart';

class EmergencyNumberBloc
    extends Bloc<EmergencyNumberEvent, EmergencyNumberState> {
  StreamSubscription _subscription;
  final EmergencyNumberRepository emergencyNumberRepository;

  EmergencyNumberBloc({
    @required this.emergencyNumberRepository,
  }) : assert(emergencyNumberRepository != null), super(InitialEmergencyNumberState());


  @override
  Stream<EmergencyNumberState> mapEventToState(
    EmergencyNumberEvent event,
  ) async* {
    if (event is ReferralHospitalLoad) {
      yield* _mapLoadreferralHospitalToState();
    } else if (event is ReferralHospitalUpdated) {
      yield* _mapreferralHospitalToState(event);
    }

    if (event is CallCenterLoad) {
      yield* _mapLoadCallCenterToState();
    } else if (event is CallCenterUpdated) {
      yield* _mapCallCenterToState(event);
    }

    if (event is GugusTugasWebLoad) {
      yield* _mapLoadGugusTugasWebToState();
    } else if (event is GugusTugasWebUpdated) {
      yield* _mapGugusTugasWebToState(event);
    }
  }

  Stream<EmergencyNumberState> _mapLoadreferralHospitalToState() async* {
    yield EmergencyNumberLoading();
    _subscription?.cancel();
    _subscription = emergencyNumberRepository
        .getReferralHospitalModelList()
        .listen((referralHospital) {
      List<ReferralHospitalModel> list = [];
      for (int i = 0; i < referralHospital.length; i++) {
        list.add(referralHospital[i]);
      }
      add(ReferralHospitalUpdated(list));
    });
  }

  Stream<EmergencyNumberState> _mapreferralHospitalToState(
      ReferralHospitalUpdated event) async* {
    yield ReferralHospitalLoaded(event.referralModel);
  }

  Stream<EmergencyNumberState> _mapLoadCallCenterToState() async* {
    yield EmergencyNumberLoading();
    _subscription?.cancel();
    _subscription =
        emergencyNumberRepository.getCallCenterModelList().listen((callCenter) {
      List<CallCenterModel> list = [];
      for (int i = 0; i < callCenter.length; i++) {
        list.add(callCenter[i]);
      }
      add(CallCenterUpdated(list));
    });
  }

  Stream<EmergencyNumberState> _mapCallCenterToState(
      CallCenterUpdated event) async* {
    yield CallCenterLoaded(event.callCenterModel);
  }

  Stream<EmergencyNumberState> _mapLoadGugusTugasWebToState() async* {
    yield EmergencyNumberLoading();
    _subscription?.cancel();
    _subscription =
        emergencyNumberRepository.getGugusTugasWebList().listen((callCenter) {
      List<GugusTugasWebModel> list = [];
      for (int i = 0; i < callCenter.length; i++) {
        list.add(callCenter[i]);
      }
      add(GugusTugasWebUpdated(list));
    });
  }

  Stream<EmergencyNumberState> _mapGugusTugasWebToState(
      GugusTugasWebUpdated event) async* {
    yield GugusTugasWebLoaded(event.gugusTugasWebModel);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
