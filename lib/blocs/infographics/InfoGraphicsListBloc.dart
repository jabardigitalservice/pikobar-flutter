import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/LabelNew.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/repositories/InfoGraphicsRepository.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import './Bloc.dart';

class InfoGraphicsListBloc
    extends Bloc<InfoGraphicsListEvent, InfoGraphicsListState> {
  final InfoGraphicsRepository _repository = InfoGraphicsRepository();
  StreamSubscription _subscription;
  // DateTime currentDay = DateTime(
  //     DateTime.now().year, DateTime.now().month, DateTime.now().day - 2);
  // DateTime yesterday = DateTime(
  //     DateTime.now().year, DateTime.now().month, DateTime.now().day - 3);

  // DateTime currentDay = DateTime.now();
  //   // DateTime yesterday = DateTime(
  //   //     DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);

  // List<LabelNewModel> dataLabel = [];

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
    // String label = await LabelNewSharedPreference.getLabelNew();
    // if (label != null) {
    //   dataLabel = LabelNewModel.decode(label);
    // }
    _subscription?.cancel();
    _subscription = infoGraphicsCollection == kAllInfographics
        ? _repository.getAllInfographicList().listen((event) {
            List<DocumentSnapshot> dataListAllinfographics = [];
            event.forEach((iterable) {
              dataListAllinfographics.addAll(iterable.toList());
            });
            dataListAllinfographics.sort(
                (b, a) => a['published_date'].compareTo(b['published_date']));
            // _insertDataLabel(dataListAllinfographics);
            LabelNew().insertDataLabel(dataListAllinfographics, Dictionary.labelInfoGraphic);
            add(InfoGraphicsListUpdate(dataListAllinfographics));
          })
        : _repository
            .getInfoGraphics(
                limit: limit, infoGraphicsCollection: infoGraphicsCollection)
            .listen(
            (data) {
              // _insertDataLabel(data);
              LabelNew().insertDataLabel(data, Dictionary.labelInfoGraphic);
              add(InfoGraphicsListUpdate(data));
            },
          );
  }

  Stream<InfoGraphicsListState> _mapUpdateInfoGraphicListToState(
      InfoGraphicsListUpdate event) async* {
    yield InfoGraphicsListLoaded(event.infoGraphicsList);
  }

  // _insertDataLabel(List<DocumentSnapshot> listData) async {
  //   listData.forEach((dataInfographic) {
  //     var dataDate = DateTime.fromMillisecondsSinceEpoch(
  //         dataInfographic['published_date'].seconds * 1000);
  //     if (dataDate.day == currentDay.day &&
  //             dataDate.month == currentDay.month &&
  //             dataDate.year == currentDay.year ||
  //         dataDate.day == yesterday.day &&
  //             dataDate.month == yesterday.month &&
  //             dataDate.year == yesterday.year) {
  //       LabelNewModel labelNewModel =
  //           LabelNewModel(id: dataInfographic.id.toString(), isRead: '0');
  //
  //       var data = dataLabel
  //           .where((test) => test.id.toLowerCase().contains(labelNewModel.id));
  //
  //       if (data.isEmpty) {
  //         dataLabel.add(labelNewModel);
  //       }
  //     }
  //   });
  //
  //   String encodeData = LabelNewModel.encode(dataLabel);
  //   await LabelNewSharedPreference.setLabelNew(encodeData);
  // }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
