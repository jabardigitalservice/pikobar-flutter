import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/AreaRepository.dart';
import 'Bloc.dart';

class SubCityListBloc extends Bloc<SubCityListEvent, SubCityListState> {
  final AreaRepository _repository = AreaRepository();
  StreamSubscription<Object> _subscription;

  SubCityListBloc() : super(InitialSubCityListState());

  @override
  Stream<SubCityListState> mapEventToState(
    SubCityListEvent event,
  ) async* {
    if (event is SubCityListLoad) {
      yield* _mapLoadSubCitysToState();
    } else if (event is SubCityListUpdate) {
      yield* _mapSubCityUpdateToState(event);
    }
  }

  Stream<SubCityListState> _mapLoadSubCitysToState() async* {
    yield SubCityListLoading();
    await _subscription?.cancel();
    _subscription = _repository
        .getSubCityList()
        .listen((subCityList) => add(SubCityListUpdate(subCityList)));
  }

  Stream<SubCityListState> _mapSubCityUpdateToState(
      SubCityListUpdate event) async* {
    yield SubCityListLoaded(event.subCityList);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
