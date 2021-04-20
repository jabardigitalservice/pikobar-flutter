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

class NewsListImportantLoad extends NewsListEvent {
  final String newsCollection;
  final bool statImportantInfo;

  NewsListImportantLoad(this.newsCollection, {this.statImportantInfo});

  @override
  String toString() {
    return 'Event NewsListImportantLoad $newsCollection';
  }

  @override
  List<Object> get props => [newsCollection];
}

class NewsListImportantUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  NewsListImportantUpdate(this.newsList);

  @override
  String toString() => 'Event NewsListImportantUpdate';

  @override
  List<Object> get props => [newsList];
}

class NewsListJabarLoad extends NewsListEvent {
  final String newsCollection;
  final bool statImportantInfo;

  NewsListJabarLoad(this.newsCollection, {this.statImportantInfo});

  @override
  String toString() {
    return 'Event NewsListJabarLoad $newsCollection';
  }

  @override
  List<Object> get props => [newsCollection];
}

class NewsListJabarUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  NewsListJabarUpdate(this.newsList);

  @override
  String toString() => 'Event NewsListJabarUpdate';

  @override
  List<Object> get props => [newsList];
}

class NewsListNationalLoad extends NewsListEvent {
  final String newsCollection;
  final bool statImportantInfo;

  NewsListNationalLoad(this.newsCollection, {this.statImportantInfo});

  @override
  String toString() {
    return 'Event NewsListNationalLoad $newsCollection';
  }

  @override
  List<Object> get props => [newsCollection];
}

class NewsListNationalUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  NewsListNationalUpdate(this.newsList);

  @override
  String toString() => 'Event NewsListNationalUpdate';

  @override
  List<Object> get props => [newsList];
}

class NewsListWorldLoad extends NewsListEvent {
  final String newsCollection;
  final bool statImportantInfo;

  NewsListWorldLoad(this.newsCollection, {this.statImportantInfo});

  @override
  String toString() {
    return 'Event NewsListWorldLoad $newsCollection';
  }

  @override
  List<Object> get props => [newsCollection];
}

class NewsListWorldUpdate extends NewsListEvent {
  final List<NewsModel> newsList;

  NewsListWorldUpdate(this.newsList);

  @override
  String toString() => 'Event NewsListWorldUpdate';

  @override
  List<Object> get props => [newsList];
}
