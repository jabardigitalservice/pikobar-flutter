import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';
import 'package:pikobar_flutter/repositories/ImportantInfoRepository.dart';
import './Bloc.dart';

class ImportantInfoDetailBloc extends Bloc<ImportantInfoDetailEvent, importantInfoDetailState> {
  @override
  importantInfoDetailState get initialState => InitialImportantInfoDetailState();

  @override
  Stream<importantInfoDetailState> mapEventToState(
    ImportantInfoDetailEvent event,
  ) async* {
    if (event is ImportantInfoDetailLoad) {
      yield ImportantInfoDetailLoading();

      ImportantinfoModel record = await ImportantInfoRepository().getImportantInfoDetail(importantInfoid: event.importantInfoId);
      yield ImportantInfoDetailLoaded(record);
    }
  }
}
