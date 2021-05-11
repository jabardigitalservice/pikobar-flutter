import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/StatisticsRepository.dart';
import 'Bloc.dart';

class RapidTestAntigenBloc
    extends Bloc<RapidTestAntigenEvent, RapidTestAntigenState> {
  StatisticsRepository statisticsRepository = StatisticsRepository();
  StreamSubscription _subscription;

  RapidTestAntigenBloc() : super(InitialRapidTestAntigenState());

  @override
  Stream<RapidTestAntigenState> mapEventToState(
    RapidTestAntigenEvent event,
  ) async* {
    if (event is RapidTestAntigenLoad) {
      yield* _mapRapidTestAntigenLoadToState();
    } else if (event is RapidTestAntigenUpdate) {
      yield* _mapRapidTestAntigenUpdateToState(event);
    }
  }

  Stream<RapidTestAntigenState> _mapRapidTestAntigenLoadToState() async* {
    yield RapidTestAntigenLoading();
    await _subscription?.cancel();
    _subscription = statisticsRepository.getRapidTestAntigen().listen(
          (statistics) => add(RapidTestAntigenUpdate(statistics)),
        );
  }

  Stream<RapidTestAntigenState> _mapRapidTestAntigenUpdateToState(
      RapidTestAntigenUpdate event) async* {
    yield RapidTestAntigenLoaded(snapshot: event.snapshot);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
