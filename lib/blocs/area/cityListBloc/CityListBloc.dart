import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/AreaRepository.dart';
import 'Bloc.dart';

class CityListBloc extends Bloc<CityListEvent, CityListState> {
  final AreaRepository _repository = AreaRepository();
  StreamSubscription _subscription;

  CityListBloc() : super(InitialCityListState());

  @override
  Stream<CityListState> mapEventToState(
    CityListEvent event,
  ) async* {
    if (event is CityListLoad) {
      yield* _mapLoadCitysToState();
    } else if (event is CityListUpdate) {
      yield* _mapCityUpdateToState(event);
    }
  }

  Stream<CityListState> _mapLoadCitysToState() async* {
    yield CityListLoading();
    _subscription?.cancel();
    _subscription = _repository
        .getCityList()
        .listen((cityList) => add(CityListUpdate(cityList)));
  }

  Stream<CityListState> _mapCityUpdateToState(CityListUpdate event) async* {
    yield CityListLoaded(event.cityList);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
