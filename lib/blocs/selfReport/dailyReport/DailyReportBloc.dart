import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pikobar_flutter/models/DailyReportModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

part 'DailyReportEvent.dart';

part 'DailyReportState.dart';

class DailyReportBloc extends Bloc<DailyReportEvent, DailyReportState> {

  DailyReportBloc() : super(DailyReportInitial());

  @override
  Stream<DailyReportState> mapEventToState(
    DailyReportEvent event,
  ) async* {
    if (event is DailyReportSave) {
      yield DailyReportLoading();

      try {
        String userId = await AuthRepository().getToken();
        await SelfReportRepository().saveDailyReport(
            userId: userId, dailyReport: event.dailyReportModel);
        if (event.dailyReportModel.id == '14') {
          await SelfReportRepository()
              .updateToCollection(userId: userId, isReminder: false);
        }
        yield DailyReportSaved();
      } catch (e) {
        yield DailyReportFailed(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
