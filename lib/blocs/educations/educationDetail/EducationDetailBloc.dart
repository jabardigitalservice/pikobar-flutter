import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';
import 'package:pikobar_flutter/repositories/EducationRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';
import './Bloc.dart';

class EducationDetailBloc
    extends Bloc<EducationDetailEvent, EducationDetailState> {
  EducationDetailBloc() : super(InitialEducationDetailState());

  @override
  Stream<EducationDetailState> mapEventToState(
    EducationDetailEvent event,
  ) async* {
    if (event is EducationDetailLoad) {
      try {
        yield EducationDetailLoading();
        EducationModel record = await EducationRepository().getEducationDetail(
            educationCollection: event.educationCollection,
            educationId: event.educationId);
        yield EducationDetailLoaded(record);
      } on Exception catch (e) {
        yield EducationDetailFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
