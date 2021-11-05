import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';
import 'package:pikobar_flutter/repositories/EducationRepository.dart';

import 'Bloc.dart';

class EducationListBloc extends Bloc<EducationListEvent, EducationListState> {
  final EducationRepository _repository = EducationRepository();
  StreamSubscription<Object> _subscription;

  EducationListBloc() : super(InitialEducationListState());

  @override
  Stream<EducationListState> mapEventToState(
    EducationListEvent event,
  ) async* {
    if (event is EducationListLoad) {
      yield* _mapLoadEducationsToState(event.educationCollection, event.limit);
    } else if (event is EducationListUpdate) {
      yield* _mapVideosUpdateToState(event);
    }
  }

  Stream<EducationListState> _mapLoadEducationsToState(
      String collection, int limit) async* {
    yield EducationLisLoading();
    await _subscription?.cancel();
    _subscription = _repository
        .getEducationList(educationCollection: collection, limit: limit)
        .listen((List<EducationModel> education) =>
            add(EducationListUpdate(education)));
  }

  Stream<EducationListState> _mapVideosUpdateToState(
      EducationListUpdate event) async* {
    yield EducationListLoaded(event.educationList);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
