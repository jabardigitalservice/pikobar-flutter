import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:pikobar_flutter/repositories/NewsRepository.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'Bloc.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final NewsRepository _repository = NewsRepository();
  StreamSubscription _subscription;
  LabelNew labelNew = LabelNew();

  NewsListBloc() : super(InitialNewsListState());

  @override
  Stream<NewsListState> mapEventToState(
    NewsListEvent event,
  ) async* {
    if (event is NewsListLoad) {
      yield* _mapLoadNewsToState(event.newsCollection,
          statImportantInfo: event.statImportantInfo);
    } else if (event is NewsListUpdate) {
      yield* _mapNewsUpdateToState(event);
    }

    if (event is NewsListImportantLoad) {
      yield* _mapLoadNewsImportantToState(event.newsCollection,
          statImportantInfo: event.statImportantInfo);
    } else if (event is NewsListImportantUpdate) {
      yield* _mapNewsUpdateImportantToState(event);
    }

    if (event is NewsListJabarLoad) {
      yield* _mapLoadNewsJabarToState(event.newsCollection,
          statImportantInfo: event.statImportantInfo);
    } else if (event is NewsListJabarUpdate) {
      yield* _mapNewsUpdateJabarToState(event);
    }

    if (event is NewsListNationalLoad) {
      yield* _mapLoadNewsNationalToState(event.newsCollection,
          statImportantInfo: event.statImportantInfo);
    } else if (event is NewsListNationalUpdate) {
      yield* _mapNewsUpdateNationalToState(event);
    }

    if (event is NewsListWorldLoad) {
      yield* _mapLoadNewsWorldToState(event.newsCollection,
          statImportantInfo: event.statImportantInfo);
    } else if (event is NewsListWorldUpdate) {
      yield* _mapNewsUpdateWorldToState(event);
    }
  }

  Stream<NewsListState> _mapLoadNewsToState(String collection,
      {bool statImportantInfo = true}) async* {
    yield NewsListLoading();
    _subscription?.cancel();
    _subscription = collection == kImportantInfor
        ? _repository
            .getInfoImportantList(improtantInfoCollection: collection)
            .listen(
            (news) {
              add(NewsListUpdate(news));
            },
          )
        : collection == NewsType.allArticles
            ? _repository.getAllNewsList(statImportantInfo).listen((event) {
                List<NewsModel> dataListAllNews = [];
                event.forEach((iterable) {
                  dataListAllNews.addAll(iterable.toList());
                });
                dataListAllNews
                    .sort((b, a) => a.publishedAt.compareTo(b.publishedAt));
                labelNew.insertDataLabel(dataListAllNews, Dictionary.labelNews);
                add(NewsListUpdate(dataListAllNews));
              })
            : _repository
                .getNewsList(newsCollection: collection)
                .listen((news) {
                add(NewsListUpdate(news));
              });
  }

  Stream<NewsListState> _mapNewsUpdateToState(NewsListUpdate event) async* {
    yield NewsListLoaded(event.newsList);
  }

  Stream<NewsListState> _mapLoadNewsImportantToState(String collection,
      {bool statImportantInfo = true}) async* {
    yield NewsListLoading();
    _subscription?.cancel();
    _subscription = collection == kImportantInfor
        ? _repository
            .getInfoImportantList(improtantInfoCollection: collection)
            .listen(
            (news) {
              add(NewsListImportantUpdate(news));
            },
          )
        : collection == NewsType.allArticles
            ? _repository.getAllNewsList(statImportantInfo).listen((event) {
                List<NewsModel> dataListAllNews = [];
                event.forEach((iterable) {
                  dataListAllNews.addAll(iterable.toList());
                });
                dataListAllNews
                    .sort((b, a) => a.publishedAt.compareTo(b.publishedAt));
                labelNew.insertDataLabel(dataListAllNews, Dictionary.labelNews);
                add(NewsListImportantUpdate(dataListAllNews));
              })
            : _repository
                .getNewsList(newsCollection: collection)
                .listen((news) {
                add(NewsListImportantUpdate(news));
              });
  }

  Stream<NewsListState> _mapNewsUpdateImportantToState(
      NewsListImportantUpdate event) async* {
    yield NewsListImportantLoaded(event.newsList);
  }

  Stream<NewsListState> _mapLoadNewsJabarToState(String collection,
      {bool statImportantInfo = true}) async* {
    yield NewsListLoading();
    _subscription?.cancel();
    _subscription = collection == kImportantInfor
        ? _repository
            .getInfoImportantList(improtantInfoCollection: collection)
            .listen(
            (news) {
              add(NewsListJabarUpdate(news));
            },
          )
        : collection == NewsType.allArticles
            ? _repository.getAllNewsList(statImportantInfo).listen((event) {
                List<NewsModel> dataListAllNews = [];
                event.forEach((iterable) {
                  dataListAllNews.addAll(iterable.toList());
                });
                dataListAllNews
                    .sort((b, a) => a.publishedAt.compareTo(b.publishedAt));
                labelNew.insertDataLabel(dataListAllNews, Dictionary.labelNews);
                add(NewsListJabarUpdate(dataListAllNews));
              })
            : _repository
                .getNewsList(newsCollection: collection)
                .listen((news) {
                add(NewsListJabarUpdate(news));
              });
  }

  Stream<NewsListState> _mapNewsUpdateJabarToState(
      NewsListJabarUpdate event) async* {
    yield NewsListJabarLoaded(event.newsList);
  }

  Stream<NewsListState> _mapLoadNewsNationalToState(String collection,
      {bool statImportantInfo = true}) async* {
    yield NewsListLoading();
    _subscription?.cancel();
    _subscription = collection == kImportantInfor
        ? _repository
            .getInfoImportantList(improtantInfoCollection: collection)
            .listen(
            (news) {
              add(NewsListNationalUpdate(news));
            },
          )
        : collection == NewsType.allArticles
            ? _repository.getAllNewsList(statImportantInfo).listen((event) {
                List<NewsModel> dataListAllNews = [];
                event.forEach((iterable) {
                  dataListAllNews.addAll(iterable.toList());
                });
                dataListAllNews
                    .sort((b, a) => a.publishedAt.compareTo(b.publishedAt));
                labelNew.insertDataLabel(dataListAllNews, Dictionary.labelNews);
                add(NewsListNationalUpdate(dataListAllNews));
              })
            : _repository
                .getNewsList(newsCollection: collection)
                .listen((news) {
                add(NewsListNationalUpdate(news));
              });
  }

  Stream<NewsListState> _mapNewsUpdateNationalToState(
      NewsListNationalUpdate event) async* {
    yield NewsListNationalLoaded(event.newsList);
  }

  Stream<NewsListState> _mapLoadNewsWorldToState(String collection,
      {bool statImportantInfo = true}) async* {
    yield NewsListLoading();
    _subscription?.cancel();
    _subscription = collection == kImportantInfor
        ? _repository
            .getInfoImportantList(improtantInfoCollection: collection)
            .listen(
            (news) {
              add(NewsListWorldUpdate(news));
            },
          )
        : collection == NewsType.allArticles
            ? _repository.getAllNewsList(statImportantInfo).listen((event) {
                List<NewsModel> dataListAllNews = [];
                event.forEach((iterable) {
                  dataListAllNews.addAll(iterable.toList());
                });
                dataListAllNews
                    .sort((b, a) => a.publishedAt.compareTo(b.publishedAt));
                labelNew.insertDataLabel(dataListAllNews, Dictionary.labelNews);
                add(NewsListWorldUpdate(dataListAllNews));
              })
            : _repository
                .getNewsList(newsCollection: collection)
                .listen((news) {
                add(NewsListWorldUpdate(news));
              });
  }

  Stream<NewsListState> _mapNewsUpdateWorldToState(
      NewsListWorldUpdate event) async* {
    yield NewsListWorldLoaded(event.newsList);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
