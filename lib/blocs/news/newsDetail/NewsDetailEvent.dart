import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NewsDetailEvent extends Equatable {
  const NewsDetailEvent([List props = const <dynamic>[]]);
}

class NewsDetailLoad extends NewsDetailEvent {

  final String newsCollection;
  final String newsId;

  NewsDetailLoad({@required this.newsCollection, @required this.newsId});

  @override
  // TODO: implement props
  List<Object> get props => [newsCollection, newsId];

}
