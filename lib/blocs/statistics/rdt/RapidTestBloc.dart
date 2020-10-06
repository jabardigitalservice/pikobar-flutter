import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/StatisticsRepository.dart';
import './Bloc.dart';

class RapidTestBloc extends Bloc<RapidTestEvent, RapidTestState> {
  StatisticsRepository statisticsRepository = StatisticsRepository();
  StreamSubscription _subscription;

  RapidTestBloc() : super(InitialRapidTestState());

  @override
  Stream<RapidTestState> mapEventToState(
    RapidTestEvent event,
  ) async* {
    if (event is RapidTestLoad) {
      yield* _mapRapidTestLoadToState();
    } else if (event is RapidTestUpdate) {
      yield* _mapRapidTestUpdateToState(event);
    }
  }

  Stream<RapidTestState> _mapRapidTestLoadToState() async* {
    yield RapidTestLoading();
    await _subscription?.cancel();
    _subscription = statisticsRepository.getRapidTest().listen(
          (statistics) => add(RapidTestUpdate(statistics)),
    );
  }

  Stream<RapidTestState> _mapRapidTestUpdateToState(RapidTestUpdate event) async* {
    yield RapidTestLoaded(snapshot: event.snapshot);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
