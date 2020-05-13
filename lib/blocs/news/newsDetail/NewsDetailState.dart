import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

abstract class NewsDetailState extends Equatable {
  const NewsDetailState([List props = const <dynamic>[]]);
}

class InitialNewsDetailState extends NewsDetailState {
  @override
  List<Object> get props => [];
}

class NewsDetailLoading extends NewsDetailState {
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class NewsDetailLoaded extends NewsDetailState {
  final NewsModel record;

  const NewsDetailLoaded(this.record);

  @override
  List<Object> get props => [record];

  @override
  String toString() => 'NewsDetailLoaded { record: $record }';
}