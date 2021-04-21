import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/IsolationCenterModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';
import 'package:pikobar_flutter/repositories/EmergencyNumberRepository.dart';
import 'Bloc.dart';

class EmergencyNumberBloc
    extends Bloc<EmergencyNumberEvent, EmergencyNumberState> {
  StreamSubscription _subscription;
  final EmergencyNumberRepository emergencyNumberRepository;

  EmergencyNumberBloc({
    @required this.emergencyNumberRepository,
  })  : assert(emergencyNumberRepository != null,
            'emergencyNumberRepository must not be null'),
        super(InitialEmergencyNumberState());

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

    if (event is IsolationCenterLoad) {
      yield* _mapLoadIsolationCenterToState();
    } else if (event is IsolationCenterUpdated) {
      yield* _mapIsolationCenterToState(event);
    }
  }

  Stream<EmergencyNumberState> _mapLoadreferralHospitalToState() async* {
    yield EmergencyNumberLoading();
    await _subscription?.cancel();
    _subscription = emergencyNumberRepository
        .getReferralHospitalModelList()
        .listen((List<ReferralHospitalModel> referralHospital) {
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
    await _subscription?.cancel();
    _subscription =
        emergencyNumberRepository.getCallCenterModelList().listen((List<CallCenterModel> callCenter) {
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
    await _subscription?.cancel();
    _subscription =
        emergencyNumberRepository.getGugusTugasWebList().listen((List<GugusTugasWebModel> callCenter) {
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

  Stream<EmergencyNumberState> _mapLoadIsolationCenterToState() async* {
    yield EmergencyNumberLoading();
    await _subscription?.cancel();
    _subscription = emergencyNumberRepository
        .getIsolationCenterModelList()
        .listen((List<IsolationCenterModel> referralHospital) {
      List<IsolationCenterModel> list = [];
      for (int i = 0; i < referralHospital.length; i++) {
        list.add(referralHospital[i]);
      }
      add(IsolationCenterUpdated(list));
    });
  }

  Stream<EmergencyNumberState> _mapIsolationCenterToState(
      IsolationCenterUpdated event) async* {
    yield IsolationCenterLoaded(event.isolationCenterModel);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
