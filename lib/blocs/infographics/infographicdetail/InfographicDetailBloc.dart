import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/repositories/InfoGraphicsRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';
import 'Bloc.dart';

class InfoGraphicDetailDetailBloc
    extends Bloc<InfoGraphicDetailEvent, InfoGraphicDetailState> {
  InfoGraphicDetailDetailBloc() : super(InitialInfoGraphicDetailState());

  @override
  Stream<InfoGraphicDetailState> mapEventToState(
    InfoGraphicDetailEvent event,
  ) async* {
    if (event is InfoGraphicDetailLoad) {
      try {
        yield InfoGraphicDetailLoading();
        final DocumentSnapshot record = await InfoGraphicsRepository()
            .getInfoGraphicDetail(
                infoGraphicCollection: event.infographicCollection,
                infoGraphicId: event.infographicId);
        yield InfoGraphicDetailLoaded(record);
      } catch (e) {
        yield InfoGraphicDetailFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
