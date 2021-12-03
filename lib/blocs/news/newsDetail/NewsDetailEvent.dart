import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NewsDetailEvent extends Equatable {
  const NewsDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class NewsDetailLoad extends NewsDetailEvent {
  final String newsCollection;
  final String newsId;

  NewsDetailLoad({required this.newsCollection, required this.newsId});

  @override
  List<Object> get props => <Object>[newsCollection, newsId];
}
