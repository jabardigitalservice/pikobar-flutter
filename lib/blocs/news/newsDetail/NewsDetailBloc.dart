import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:pikobar_flutter/repositories/NewsRepository.dart';
import './Bloc.dart';

class NewsDetailBloc extends Bloc<NewsDetailEvent, NewsDetailState> {
  @override
  NewsDetailState get initialState => InitialNewsDetailState();

  @override
  Stream<NewsDetailState> mapEventToState(
    NewsDetailEvent event,
  ) async* {
    if (event is NewsDetailLoad) {
      yield NewsDetailLoading();
      NewsModel record = event.newsCollection == Collections.importantInfor
          ? await NewsRepository()
              .getImportantInfoDetail(importantInfoid: event.newsId)
          : await NewsRepository().getNewsDetail(
              newsCollection: event.newsCollection, newsId: event.newsId);
      yield NewsDetailLoaded(record);
    }
  }
}
