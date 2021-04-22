import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

abstract class NewsListState extends Equatable {
  const NewsListState([List props = const <dynamic>[]]);
}

class InitialNewsListState extends NewsListState {
  @override
  List<Object> get props => [];
}

class NewsListLoading extends NewsListState {
  @override
  List<Object> get props => [];
}

class NewsListLoaded extends NewsListState {
  final List<NewsModel> newsList;

  NewsListLoaded(this.newsList);

  @override
  List<Object> get props => [newsList];
}

class NewsListImportantLoaded extends NewsListState {
  final List<NewsModel> newsList;

  NewsListImportantLoaded(this.newsList);

  @override
  List<Object> get props => [newsList];
}

class NewsListJabarLoaded extends NewsListState {
  final List<NewsModel> newsList;

  NewsListJabarLoaded(this.newsList);

  @override
  List<Object> get props => [newsList];
}

class NewsListNationalLoaded extends NewsListState {
  final List<NewsModel> newsList;

  NewsListNationalLoaded(this.newsList);

  @override
  List<Object> get props => [newsList];
}

class NewsListWorldLoaded extends NewsListState {
  final List<NewsModel> newsList;

  NewsListWorldLoaded(this.newsList);

  @override
  List<Object> get props => [newsList];
}
