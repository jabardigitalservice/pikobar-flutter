import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/ContactHistoryModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

part 'ContactHistorySaveEvent.dart';
part 'ContactHistorySaveState.dart';

class ContactHistorySaveBloc extends Bloc<ContactHistorySaveEvent, ContactHistorySaveState> {

  @override
  ContactHistorySaveState get initialState => ContactHistorySaveInitial();

  @override
  Stream<ContactHistorySaveState> mapEventToState(
    ContactHistorySaveEvent event,
  ) async* {
    if (event is ContactHistorySave) {
      yield ContactHistorySaveLoading();

      try {
        String userId = await AuthRepository().getToken();
        await SelfReportRepository().saveContactHistory(
            userId: userId, data: event.data);

        yield ContactHistorySaved();
      } catch (e) {
        yield ContactHistorySaveFailure(error: CustomException.onConnectionException(e.toString()));
      }
    }
  }

}
