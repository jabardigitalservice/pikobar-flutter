import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';
import 'package:pikobar_flutter/repositories/ImportantInfoRepository.dart';
import './Bloc.dart';

class ImportantInfoDetailBloc
    extends Bloc<ImportantInfoDetailEvent, ImportantInfoDetailState> {
  ImportantInfoDetailBloc() : super(InitialImportantInfoDetailState());

  @override
  Stream<ImportantInfoDetailState> mapEventToState(
    ImportantInfoDetailEvent event,
  ) async* {
    if (event is ImportantInfoDetailLoad) {
      yield ImportantInfoDetailLoading();

      ImportantInfoModel record = await ImportantInfoRepository()
          .getImportantInfoDetail(importantInfoid: event.importantInfoId);
      yield ImportantInfoDetailLoaded(record);
    }
  }
}
