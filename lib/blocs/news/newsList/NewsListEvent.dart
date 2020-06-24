import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

abstract class NewsListEvent extends Equatable {
  const NewsListEvent([List props = const <dynamic>[]]);
}

class NewsListLoad extends NewsListEvent {
  final String newsCollection;
  final bool statImportantInfo;

  NewsListLoad(this.newsCollection, {this.statImportantInfo});

  @override
  String toString() {
    return 'Event NewsListLoad $newsCollection';
  }

  @override
  List<Object> get props => [newsCollection];
}

class NewsListUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  NewsListUpdate(this.newsList);

  @override
  String toString() => 'Event NewsListUpdate';

  @override
  List<Object> get props => [newsList];
}
