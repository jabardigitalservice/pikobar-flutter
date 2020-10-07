import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';

part 'SelfReportDetailEvent.dart';

part 'SelfReportDetailState.dart';

class SelfReportDetailBloc
    extends Bloc<SelfReportDetailEvent, SelfReportDetailState> {

  SelfReportDetailBloc() : super(SelfReportDetailInitial());

  @override
  Stream<SelfReportDetailState> mapEventToState(
    SelfReportDetailEvent event,
  ) async* {
    if (event is SelfReportDetailLoad) {
      yield SelfReportDetailLoading();

      try {
        String userId = await AuthRepository().getToken();
        DocumentSnapshot doc = await SelfReportRepository().getSelfReportDetail(
            userId: userId, dailyReportId: event.selfReportId);
        yield SelfReportDetailLoaded(documentSnapshot: doc);
      } catch (error) {
        yield SelfReportDetailFailure(error: error.toString());
      }
    }
  }
}
