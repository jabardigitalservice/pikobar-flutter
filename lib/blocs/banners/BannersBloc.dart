import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/BannersRepository.dart';
import 'Bloc.dart';

class BannersBloc extends Bloc<BannersEvent, BannersState> {
  final BannersRepository _repository = BannersRepository();
  StreamSubscription _subscription;

  BannersBloc() : super(InitialBannersState());

  @override
  Stream<BannersState> mapEventToState(
    BannersEvent event,
  ) async* {
    if (event is BannersLoad) {
      yield* _mapBannersLoadToState();
    } else if (event is BannersUpdate) {
      yield* _mapBannersUpdateToState(event);
    }
  }

  Stream<BannersState> _mapBannersLoadToState() async* {
    yield BannersLoading();
    await _subscription?.cancel();
    _subscription = _repository.getBanners().listen(
          (banners) => add(BannersUpdate(banners)),
        );
  }

  Stream<BannersState> _mapBannersUpdateToState(BannersUpdate event) async* {
    yield BannersLoaded(records: event.records);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
