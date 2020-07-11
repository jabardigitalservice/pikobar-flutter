import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/EducationRepository.dart';
import 'Bloc.dart';

class EducationListBloc extends Bloc<EducationListEvent, EducationListState> {
  final EducationRepository _repository = EducationRepository();
  StreamSubscription _subscription;

  @override
  EducationListState get initialState => InitialEducationListState();

  @override
  Stream<EducationListState> mapEventToState(
    EducationListEvent event,
  ) async* {
    if (event is EducationListLoad) {
      yield* _mapLoadVideosToState(event.educationCollection);
    } else if (event is EducationListUpdate) {
      yield* _mapVideosUpdateToState(event);
    }
  }

  Stream<EducationListState> _mapLoadVideosToState(String collection,
      {bool statImportantInfo = true}) async* {
    yield EducationLisLoading();
    _subscription?.cancel();
    _subscription =  _repository
                .getEducationList(educationCollection: collection)
                .listen((education) => add(EducationListUpdate(education)));
  }

  Stream<EducationListState> _mapVideosUpdateToState(
      EducationListUpdate event) async* {
    yield EducationListLoaded(event.educationList);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
