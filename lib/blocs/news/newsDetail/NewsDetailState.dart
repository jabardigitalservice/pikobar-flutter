import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

abstract class NewsDetailState extends Equatable {
  const NewsDetailState();

  @override
  List<Object> get props => <Object>[];
}

class InitialNewsDetailState extends NewsDetailState {}

class NewsDetailLoading extends NewsDetailState {}

class NewsDetailLoaded extends NewsDetailState {
  final NewsModel record;

  const NewsDetailLoaded(this.record);

  @override
  List<Object> get props => <Object>[record];
}

class NewsDetailFailure extends NewsDetailState {
  final String error;

  const NewsDetailFailure({required this.error});

  @override
  String toString() => 'State NewsDetailFailure{error: $error}';

  @override
  List<Object> get props => <Object>[error];
}
