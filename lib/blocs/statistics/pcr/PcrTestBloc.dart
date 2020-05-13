import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/StatisticsRepository.dart';
import './Bloc.dart';

class PcrTestBloc extends Bloc<PcrTestEvent, PcrTestState> {
  StatisticsRepository statisticsRepository = StatisticsRepository();
  StreamSubscription _subscription;

  @override
  PcrTestState get initialState => InitialPcrTestState();

  @override
  Stream<PcrTestState> mapEventToState(
    PcrTestEvent event,
  ) async* {
    if (event is PcrTestLoad) {
      yield* _mapPcrTestLoadToState();
    } else if (event is PcrTestUpdate) {
      yield* _mapPcrTestUpdateToState(event);
    }
  }

  Stream<PcrTestState> _mapPcrTestLoadToState() async* {
    yield PcrTestLoading();
    await _subscription?.cancel();
    _subscription = statisticsRepository.getPCRTest().listen(
          (statistics) => add(PcrTestUpdate(statistics)),
    );
  }

  Stream<PcrTestState> _mapPcrTestUpdateToState(PcrTestUpdate event) async* {
    yield PcrTestLoaded(snapshot: event.snapshot);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
