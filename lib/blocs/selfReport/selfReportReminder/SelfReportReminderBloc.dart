import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/HealthStatus.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';

part 'SelfReportReminderEvent.dart';

part 'SelfReportReminderState.dart';

class SelfReportReminderBloc
    extends Bloc<SelfReportReminderEvent, SelfReportReminderState> {
  StreamSubscription _subscription;

  SelfReportReminderBloc() : super(SelfReportReminderInitial());

  @override
  Stream<SelfReportReminderState> mapEventToState(
    SelfReportReminderEvent event,
  ) async* {
    if (event is SelfReportReminderListLoad) {
      yield* _loadSelfReportReminderToState();
    } else if (event is SelfReportReminderUpdated) {
      yield* _selfReportReminderToState(event);
    }

    if (event is SelfReportListUpdateReminder) {
      yield SelfReportReminderLoading();
      try {
        final String userId = await AuthRepository().getToken();
        await SelfReportRepository()
            .updateToCollection(userId: userId, isReminder: event.isReminder);
        yield SelfReportIsreminderSaved();
      } catch (e) {
        yield SelfReportReminderFailure(error: e.toString());
      }
    }

    if (event is SelfReportUpdateRecurrenceReport) {
      yield SelfReportReminderLoading();
      try {
        final String userId = await AuthRepository().getToken();
        await SelfReportRepository().updateRecurrenceReport(
            userId: userId, recurrenceReport: event.recurrenceReport);
        final String tempHealthStatus =
            await HealthStatusSharedPreference.getTempHealthStatus();
        await HealthStatusSharedPreference.setHealthStatus(tempHealthStatus);
        yield SelfReportRecurrenceReportSaved();
      } catch (e) {
        yield SelfReportReminderFailure(error: e.toString());
      }
    }
  }

  Stream<SelfReportReminderState> _loadSelfReportReminderToState() async* {
    yield SelfReportReminderLoading();
    await _subscription?.cancel();
    String userId = await AuthRepository().getToken();

    _subscription =
        SelfReportRepository().getIsReminder(userId: userId).listen((event) {
      add(SelfReportReminderUpdated(event));
    });
  }

  Stream<SelfReportReminderState> _selfReportReminderToState(
      SelfReportReminderUpdated event) async* {
    yield SelfReportIsReminderLoaded(
        querySnapshot: event.selfReportReminderList);
  }
}
