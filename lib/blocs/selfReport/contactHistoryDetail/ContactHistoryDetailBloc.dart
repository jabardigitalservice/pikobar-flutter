import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';

part 'ContactHistoryDetailEvent.dart';

part 'ContactHistoryDetailState.dart';

class ContactHistoryDetailBloc
    extends Bloc<ContactHistoryDetailEvent, ContactHistoryDetailState> {
  @override
  ContactHistoryDetailState get initialState => ContactHistoryDetailInitial();

  @override
  Stream<ContactHistoryDetailState> mapEventToState(
    ContactHistoryDetailEvent event,
  ) async* {
    if (event is ContactHistoryDetailLoad) {
      yield ContactHistoryDetailLoading();

      try {
        String userId = await AuthRepository().getToken();
        DocumentSnapshot doc = await SelfReportRepository().getContactHistoryDetail(
            userId: userId, contactHistoryId: event.contactHistoryId);

        yield ContactHistoryDetailLoaded(documentSnapshot: doc);
      } catch (error) {
        yield ContactHistoryDetailFailure(error: error.toString());
      }
    }
  }
}
