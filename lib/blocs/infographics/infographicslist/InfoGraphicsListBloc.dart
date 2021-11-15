import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/repositories/InfoGraphicsRepository.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';

import 'Bloc.dart';

class InfoGraphicsListBloc
    extends Bloc<InfoGraphicsListEvent, InfoGraphicsListState> {
  final InfoGraphicsRepository _repository = InfoGraphicsRepository();
  LabelNew labelNew = LabelNew();
  StreamSubscription<Object> _subscription;

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

    if (event is InfoGraphicsListJabarLoad) {
      yield* _mapLoadInfoGraphicsListJabarToState(
          limit: event.limit,
          infoGraphicsCollection: event.infoGraphicsCollection);
    } else if (event is InfoGraphicsListJabarUpdate) {
      yield* _mapUpdateInfoGraphicListJabarToState(event);
    }

    if (event is InfoGraphicsListPusatLoad) {
      yield* _mapLoadInfoGraphicsListPusatToState(
          limit: event.limit,
          infoGraphicsCollection: event.infoGraphicsCollection);
    } else if (event is InfoGraphicsListPusatUpdate) {
      yield* _mapUpdateInfoGraphicListPusatToState(event);
    }

    if (event is InfoGraphicsListWHOLoad) {
      yield* _mapLoadInfoGraphicsListWHOToState(
          limit: event.limit,
          infoGraphicsCollection: event.infoGraphicsCollection);
    } else if (event is InfoGraphicsListWHOUpdate) {
      yield* _mapUpdateInfoGraphicListWHOToState(event);
    }
  }

  void _loadData(String infoGraphicsCollection, int limit) {
    _subscription?.cancel();
    _subscription = infoGraphicsCollection == kAllInfographics
        ? _repository.getAllInfographicList().listen((event) {
            List<DocumentSnapshot> dataListAllinfographics =
                <DocumentSnapshot>[];

            for (final iterable in event) {
              dataListAllinfographics.addAll(iterable.toList());
            }

            dataListAllinfographics.sort(
                (DocumentSnapshot b, DocumentSnapshot a) =>
                    a['published_date'].compareTo(b['published_date']));

            labelNew.insertDataLabel(
                dataListAllinfographics, Dictionary.labelInfoGraphic);

            if (limit != null) {
              int maxLimit = limit <= dataListAllinfographics.length
                  ? limit
                  : dataListAllinfographics.length;
              dataListAllinfographics =
                  dataListAllinfographics.getRange(0, maxLimit).toList();
            }

            add(InfoGraphicsListUpdate(dataListAllinfographics));
          })
        : _repository
            .getInfoGraphics(
                limit: limit, infoGraphicsCollection: infoGraphicsCollection)
            .listen(
            (data) {
              switch (infoGraphicsCollection) {
                case kAllInfographics:
                  add(InfoGraphicsListUpdate(data));
                  break;
                case kInfographics:
                  add(InfoGraphicsListJabarUpdate(data));
                  break;
                case kInfographicsCenter:
                  add(InfoGraphicsListPusatUpdate(data));
                  break;
                case kInfographicsWho:
                  add(InfoGraphicsListWHOUpdate(data));
                  break;
                default:
                  add(InfoGraphicsListUpdate(data));
              }
            },
          );
  }

  Stream<InfoGraphicsListState> _mapLoadInfoGraphicsListToState(
      {int limit, String infoGraphicsCollection}) async* {
    yield InfoGraphicsListLoading();
    _loadData(infoGraphicsCollection, limit);
  }

  Stream<InfoGraphicsListState> _mapUpdateInfoGraphicListToState(
      InfoGraphicsListUpdate event) async* {
    yield InfoGraphicsListLoaded(event.infoGraphicsList);
  }

  Stream<InfoGraphicsListState> _mapLoadInfoGraphicsListJabarToState(
      {int limit, String infoGraphicsCollection}) async* {
    yield InfoGraphicsListLoading();
    _loadData(infoGraphicsCollection, limit);
  }

  Stream<InfoGraphicsListState> _mapUpdateInfoGraphicListJabarToState(
      InfoGraphicsListJabarUpdate event) async* {
    yield InfoGraphicsListJabarLoaded(event.infoGraphicsListJabar);
  }

  Stream<InfoGraphicsListState> _mapLoadInfoGraphicsListPusatToState(
      {int limit, String infoGraphicsCollection}) async* {
    yield InfoGraphicsListLoading();
    _loadData(infoGraphicsCollection, limit);
  }

  Stream<InfoGraphicsListState> _mapUpdateInfoGraphicListPusatToState(
      InfoGraphicsListPusatUpdate event) async* {
    yield InfoGraphicsListPusatLoaded(event.infoGraphicsListPusat);
  }

  Stream<InfoGraphicsListState> _mapLoadInfoGraphicsListWHOToState(
      {int limit, String infoGraphicsCollection}) async* {
    yield InfoGraphicsListLoading();
    _loadData(infoGraphicsCollection, limit);
  }

  Stream<InfoGraphicsListState> _mapUpdateInfoGraphicListWHOToState(
      InfoGraphicsListWHOUpdate event) async* {
    yield InfoGraphicsListWHOLoaded(event.infoGraphicsListWHO);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
