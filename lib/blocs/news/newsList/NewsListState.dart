import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

abstract class NewsListState extends Equatable {
  const NewsListState();

  @override
  List<Object> get props => <Object>[];
}

class InitialNewsListState extends NewsListState {}

class NewsListLoading extends NewsListState {}

class NewsListLoaded extends NewsListState {
  final List<NewsModel> newsList;

  const NewsListLoaded(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}

class NewsListImportantLoaded extends NewsListState {
  final List<NewsModel> newsList;

  const NewsListImportantLoaded(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}

class NewsListJabarLoaded extends NewsListState {
  final List<NewsModel> newsList;

  const NewsListJabarLoaded(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}

class NewsListNationalLoaded extends NewsListState {
  final List<NewsModel> newsList;

  const NewsListNationalLoaded(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}

class NewsListWorldLoaded extends NewsListState {
  final List<NewsModel> newsList;

  const NewsListWorldLoaded(this.newsList);

  @override
  List<Object> get props => <Object>[newsList];
}
