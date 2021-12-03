import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:pikobar_flutter/repositories/ImportantInfoRepository.dart';
import 'Bloc.dart';

class ImportantInfoListBloc
    extends Bloc<ImportantInfoListEvent, ImportantInfoListState> {
  final ImportantInfoRepository _repository = ImportantInfoRepository();
  late StreamSubscription<Object> _subscription;

  ImportantInfoListBloc() : super(InitialImportantInfoListState());

  @override
  Stream<ImportantInfoListState> mapEventToState(
    ImportantInfoListEvent event,
  ) async* {
    if (event is ImportantInfoListLoad) {
      yield* _mapLoadVideosToState(event.importantInfoCollection);
    } else if (event is ImportantInfoListUpdate) {
      yield* _mapVideosUpdateToState(event);
    }
  }

  Stream<ImportantInfoListState> _mapLoadVideosToState(
      String collection) async* {
    yield ImportantInfoListLoading();
    await _subscription.cancel();
    _subscription = _repository
        .getInfoImportantList(improtantInfoCollection: collection)
        .listen((importantInfo) {
      List<NewsModel> list = <NewsModel>[];
      for (int i = 0; i < importantInfo.length; i++) {
        if (importantInfo[i].published) {
          list.add(importantInfo[i]);
        }
      }
      add(ImportantInfoListUpdate(list));
    });
  }

  Stream<ImportantInfoListState> _mapVideosUpdateToState(
      ImportantInfoListUpdate event) async* {
    yield ImportantInfoListLoaded(event.importantInfoList);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
