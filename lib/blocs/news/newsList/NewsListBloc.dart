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

  NewsListBloc() : super(InitialNewsListState());

  @override
  Stream<NewsListState> mapEventToState(
    NewsListEvent event,
  ) async* {
    if (event is NewsListLoad) {
      yield* _mapLoadVideosToState(event.newsCollection,
          statImportantInfo: event.statImportantInfo);
    } else if (event is NewsListUpdate) {
      yield* _mapVideosUpdateToState(event);
    }
  }

  Stream<NewsListState> _mapLoadVideosToState(String collection,
      {bool statImportantInfo = true}) async* {
    yield NewsListLoading();
    _subscription?.cancel();
    _subscription = collection == kImportantInfor
        ? _repository
            .getInfoImportantList(improtantInfoCollection: collection)
            .listen(
            (news) {
              LabelNew().insertDataLabel(news, Dictionary.labelNews);
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
                LabelNew()
                    .insertDataLabel(dataListAllNews, Dictionary.labelNews);
                add(NewsListUpdate(dataListAllNews));
              })
            : _repository
                .getNewsList(newsCollection: collection)
                .listen((news) {
                LabelNew().insertDataLabel(news, Dictionary.labelNews);
                add(NewsListUpdate(news));
              });
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
