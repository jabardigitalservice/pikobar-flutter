import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/repositories/InfoGraphicsRepository.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import './Bloc.dart';

class InfoGraphicsListBloc
    extends Bloc<InfoGraphicsListEvent, InfoGraphicsListState> {
  final InfoGraphicsRepository _repository = InfoGraphicsRepository();
  LabelNew labelNew = LabelNew();
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
    _subscription = infoGraphicsCollection == kAllInfographics
        ? _repository.getAllInfographicList().listen((event) {
            List<DocumentSnapshot> dataListAllinfographics = [];
            event.forEach((iterable) {
              dataListAllinfographics.addAll(iterable.toList());
            });
            dataListAllinfographics.sort(
                (b, a) => a['published_date'].compareTo(b['published_date']));
            labelNew.insertDataLabel(
                dataListAllinfographics, Dictionary.labelInfoGraphic);
            add(InfoGraphicsListUpdate(dataListAllinfographics));
          })
        : _repository
            .getInfoGraphics(
                limit: limit, infoGraphicsCollection: infoGraphicsCollection)
            .listen(
            (data) {
              add(InfoGraphicsListUpdate(data));
            },
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
