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

