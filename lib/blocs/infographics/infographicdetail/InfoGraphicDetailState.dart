import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class InfoGraphicDetailState extends Equatable {
  const InfoGraphicDetailState([List props = const <dynamic>[]]);
}

class InitialInfoGraphicDetailState extends InfoGraphicDetailState {
  @override
  List<Object> get props => [];
}

class InfoGraphicDetailLoading extends InfoGraphicDetailState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InfoGraphicDetailLoaded extends InfoGraphicDetailState {
  final DocumentSnapshot record;

  const InfoGraphicDetailLoaded(this.record);

  @override
  List<Object> get props => [record];

  @override
  String toString() => 'InfoGraphicDetailLoaded { record: $record }';
}

class InfoGraphicDetailFailure extends InfoGraphicDetailState {
  final String error;

  InfoGraphicDetailFailure({this.error});

  @override
  String toString() {
    return 'State InfoGraphicDetailFailure{error: $error}';
  }

  @override
  List<Object> get props => [error];
}
