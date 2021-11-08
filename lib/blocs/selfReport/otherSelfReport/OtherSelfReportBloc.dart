import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';

part 'OtherSelfReportEvent.dart';

part 'OtherSelfReportState.dart';

class OtherSelfReportBloc
    extends Bloc<OtherSelfReportEvent, OtherSelfReportState> {
  StreamSubscription<Object> _subscription;

  OtherSelfReportBloc() : super(OtherSelfReportInitial());

  @override
  Stream<OtherSelfReportState> mapEventToState(
    OtherSelfReportEvent event,
  ) async* {
    if (event is OtherSelfReportLoad) {
      yield* _loadOtherSelfReportToState();
    } else if (event is OtherSelfReportUpdated) {
      yield* _selfReportListToState(event);
    }
  }

  Stream<OtherSelfReportState> _loadOtherSelfReportToState() async* {
    yield OtherSelfReportLoading();
    await _subscription?.cancel();
    String userId = await AuthRepository().getToken();

    _subscription = SelfReportRepository()
        .getOtherSelfReport(userId: userId)
        .listen((event) {
      add(OtherSelfReportUpdated(event));
    });
  }

  Stream<OtherSelfReportState> _selfReportListToState(
      OtherSelfReportUpdated event) async* {
    yield OtherSelfReportLoaded(querySnapshot: event.selfReportList);
  }
}
