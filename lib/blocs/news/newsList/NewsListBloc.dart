import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/repositories/NewsRepository.dart';
import 'Bloc.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final NewsRepository _repository = NewsRepository();
  StreamSubscription _subscription;

  @override
  NewsListState get initialState => InitialNewsListState();

  @override
  Stream<NewsListState> mapEventToState(
    NewsListEvent event,
  ) async* {
    if (event is NewsListLoad) {
      yield* _mapLoadVideosToState(event.newsCollection);
    } else if (event is NewsListUpdate) {
      yield* _mapVideosUpdateToState(event);
    }
  }

  Stream<NewsListState> _mapLoadVideosToState(String collection) async* {
    yield NewsListLoading();
    _subscription?.cancel();
    _subscription = collection == Collections.importantInfor
        ? _repository
            .getInfoImportantList(improtantInfoCollection: collection)
            .listen(
              (news) => add(NewsListUpdate(news)),
            )
        : _repository
            .getNewsList(newsCollection: collection)
            .listen((news) => add(NewsListUpdate(news)));
  }

  Stream<NewsListState> _mapVideosUpdateToState(NewsListUpdate event) async* {
    yield NewsListLoaded(event.newsList);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
