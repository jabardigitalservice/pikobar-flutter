import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';

part 'ContactHistoryListEvent.dart';

part 'ContactHistoryListState.dart';

class ContactHistoryListBloc
    extends Bloc<ContactHistoryListEvent, ContactHistoryListState> {
  StreamSubscription _subscription;
  @override
  ContactHistoryListState get initialState => ContactHistoryListInitial();

  @override
  Stream<ContactHistoryListState> mapEventToState(
    ContactHistoryListEvent event,
  ) async* {
    if (event is ContactHistoryListLoad) {
      yield* _loadContactHistoryListToState();
    } else if (event is ContactHistoryListUpdated) {
      yield* _contactHistoryListToState(event);
    }

  }

 

  Stream<ContactHistoryListState> _loadContactHistoryListToState() async* {
    yield ContactHistoryListLoading();
    _subscription?.cancel();
    String userId = await AuthRepository().getToken();

    _subscription = SelfReportRepository()
        .getContactHistoryList(userId: userId)
        .listen((event) {
      add(ContactHistoryListUpdated(event));
    });
  }



  Stream<ContactHistoryListState> _contactHistoryListToState(
      ContactHistoryListUpdated event) async* {
      yield ContactHistoryListLoaded(
          querySnapshot: event.contactHistoryList);
    
  }

 
}
