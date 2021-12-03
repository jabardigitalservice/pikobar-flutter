import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

abstract class NewsListEvent extends Equatable {
  const NewsListEvent();

  @override
  List<Object> get props => <Object>[];
}

class NewsListLoad extends NewsListEvent {
  final String newsCollection;
  final bool statImportantInfo;
  final int limit;

  const NewsListLoad(this.newsCollection,
      {required this.statImportantInfo, required this.limit});

  @override
  List<Object> get props => <Object>[newsCollection, limit];
}

class NewsListUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  const NewsListUpdate(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}

class NewsListImportantUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  const NewsListImportantUpdate(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}

class NewsListJabarUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  const NewsListJabarUpdate(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}

class NewsListNationalUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  const NewsListNationalUpdate(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}

class NewsListWorldUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  const NewsListWorldUpdate(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}
