import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:pikobar_flutter/repositories/NewsRepository.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'Bloc.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final NewsRepository _repository = NewsRepository();
  StreamSubscription<Object> _subscription;
  LabelNew labelNew = LabelNew();

  NewsListBloc() : super(InitialNewsListState());

  @override
  Stream<NewsListState> mapEventToState(
    NewsListEvent event,
  ) async* {
    if (event is NewsListLoad) {
      yield* _mapLoadNewsToState(event.newsCollection,
          statImportantInfo: event.statImportantInfo, limit: event.limit);
    } else if (event is NewsListUpdate) {
      yield* _mapNewsUpdateToState(event);
    } else if (event is NewsListImportantUpdate) {
      yield* _mapNewsUpdateImportantToState(event);
    } else if (event is NewsListJabarUpdate) {
      yield* _mapNewsUpdateJabarToState(event);
    } else if (event is NewsListNationalUpdate) {
      yield* _mapNewsUpdateNationalToState(event);
    } else if (event is NewsListWorldUpdate) {
      yield* _mapNewsUpdateWorldToState(event);
    }
  }



  _loadData(String collection, bool statImportantInfo, int limit) {
    _subscription?.cancel();
    _subscription = collection == NewsType.articlesImportantInfo
        ? _repository
            .getInfoImportantList(
                improtantInfoCollection: collection, limit: limit)
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

                if (limit != null) {
                  dataListAllNews = dataListAllNews.getRange(0, limit).toList();
                }

                add(NewsListUpdate(dataListAllNews));
              })
            : _repository
                .getNewsList(newsCollection: collection, limit: limit)
                .listen((news) {
                switch (collection) {
                  case NewsType.articlesImportantInfo:
                    add(NewsListImportantUpdate(news));
                    break;
                  case NewsType.articles:
                    add(NewsListJabarUpdate(news));
                    break;
                  case NewsType.articlesNational:
                    add(NewsListNationalUpdate(news));
                    break;
                  case NewsType.articlesWorld:
                    add(NewsListWorldUpdate(news));
                    break;
                  default:
                    add(NewsListUpdate(news));
                }
              });
  }

  Stream<NewsListState> _mapLoadNewsToState(String collection,
      {bool statImportantInfo = true, int limit}) async* {
    yield NewsListLoading();
    _loadData(collection, statImportantInfo, limit);
  }

  Stream<NewsListState> _mapNewsUpdateToState(NewsListUpdate event) async* {
    yield NewsListLoaded(event.newsList);
  }

  Stream<NewsListState> _mapNewsUpdateImportantToState(
      NewsListImportantUpdate event) async* {
    yield NewsListImportantLoaded(event.newsList);
  }

  Stream<NewsListState> _mapNewsUpdateJabarToState(
      NewsListJabarUpdate event) async* {
    yield NewsListJabarLoaded(event.newsList);
  }

  Stream<NewsListState> _mapNewsUpdateNationalToState(
      NewsListNationalUpdate event) async* {
    yield NewsListNationalLoaded(event.newsList);
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
