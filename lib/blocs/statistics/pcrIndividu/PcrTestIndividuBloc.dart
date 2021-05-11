import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/StatisticsRepository.dart';
import 'Bloc.dart';

class PcrTestIndividuBloc
    extends Bloc<PcrTestIndividuEvent, PcrTestIndividuState> {
  StatisticsRepository statisticsRepository = StatisticsRepository();
  StreamSubscription _subscription;

  PcrTestIndividuBloc() : super(InitialPcrTestIndividuState());

  @override
  Stream<PcrTestIndividuState> mapEventToState(
    PcrTestIndividuEvent event,
  ) async* {
    if (event is PcrTestIndividuLoad) {
      yield* _mapPcrTestIndividuLoadToState();
    } else if (event is PcrTestIndividuUpdate) {
      yield* _mapPcrTestIndividuUpdateToState(event);
    }
  }

  Stream<PcrTestIndividuState> _mapPcrTestIndividuLoadToState() async* {
    yield PcrTestIndividuLoading();
    await _subscription?.cancel();
    _subscription = statisticsRepository.getPcrTestIndividu().listen(
          (statistics) => add(PcrTestIndividuUpdate(statistics)),
        );
  }

  Stream<PcrTestIndividuState> _mapPcrTestIndividuUpdateToState(
      PcrTestIndividuUpdate event) async* {
    yield PcrTestIndividuLoaded(snapshot: event.snapshot);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
