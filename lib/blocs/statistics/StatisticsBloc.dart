import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/StatisticsRepository.dart';
import './Bloc.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsRepository statisticsRepository = StatisticsRepository();
  StreamSubscription _subscription;

  StatisticsBloc() : super(InitialStatisticsState());

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    if (event is StatisticsLoad) {
      yield* _mapStatisticsLoadToState();
    } else if (event is StatisticsUpdate) {
      yield* _mapStatisticsUpdateToState(event);
    }
  }

  Stream<StatisticsState> _mapStatisticsLoadToState() async* {
    yield StatisticsLoading();
    await _subscription?.cancel();
    _subscription = statisticsRepository.getStatistics().listen(
          (statistics) => add(StatisticsUpdate(statistics)),
    );
  }

  Stream<StatisticsState> _mapStatisticsUpdateToState(StatisticsUpdate event) async* {
    yield StatisticsLoaded(snapshot: event.snapshot);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

}
