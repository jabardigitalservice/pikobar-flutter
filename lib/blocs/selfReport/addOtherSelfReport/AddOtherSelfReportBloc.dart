import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pikobar_flutter/models/AddOtherSelfReportModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

part 'AddOtherSelfReportEvent.dart';

part 'AddOtherSelfReportState.dart';

class AddOtherSelfReportBloc
    extends Bloc<AddOtherSelfReportEvent, AddOtherSelfReportState> {
  AddOtherSelfReportBloc() : super(AddOtherSelfReportInitial());

  @override
  Stream<AddOtherSelfReportState> mapEventToState(
    AddOtherSelfReportEvent event,
  ) async* {
    if (event is AddOtherSelfReportSave) {
      yield AddOtherSelfReportLoading();

      try {
        String userId = await AuthRepository().getToken();
        await SelfReportRepository().saveOtherUser(
          userId: userId,
          dailyReport: event.dailyReportModel,
        );

        yield AddOtherSelfReportSaved();
      } catch (e) {
        yield AddOtherSelfReportFailed(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
