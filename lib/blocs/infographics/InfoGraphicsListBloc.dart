import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/InfoGraphicsRepository.dart';
import './Bloc.dart';

class InfoGraphicsListBloc
    extends Bloc<InfoGraphicsListEvent, InfoGraphicsListState> {
  final InfoGraphicsRepository _repository = InfoGraphicsRepository();
  StreamSubscription _subscription;

  InfoGraphicsListBloc() : super(InitialInfoGraphicsListState());

  @override
  Stream<InfoGraphicsListState> mapEventToState(
    InfoGraphicsListEvent event,
  ) async* {
    if (event is InfoGraphicsListLoad) {
      yield* _mapLoadInfoGraphicsListToState(
          limit: event.limit,
          infoGraphicsCollection: event.infoGraphicsCollection);
    } else if (event is InfoGraphicsListUpdate) {
      yield* _mapUpdateInfoGraphicListToState(event);
    }
  }

  Stream<InfoGraphicsListState> _mapLoadInfoGraphicsListToState(
      {int limit, String infoGraphicsCollection}) async* {
    yield InfoGraphicsListLoading();
    _subscription?.cancel();
    _subscription = _repository
        .getInfoGraphics(
            limit: limit, infoGraphicsCollection: infoGraphicsCollection)
        .listen(
          (data) => add(InfoGraphicsListUpdate(data)),
        );
  }

  Stream<InfoGraphicsListState> _mapUpdateInfoGraphicListToState(
      InfoGraphicsListUpdate event) async* {
    yield InfoGraphicsListLoaded(event.infoGraphicsList);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
