import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class InfoGraphicDetailState extends Equatable {
  const InfoGraphicDetailState();

  @override
  List<Object> get props => <Object>[];
}

class InitialInfoGraphicDetailState extends InfoGraphicDetailState {}

class InfoGraphicDetailLoading extends InfoGraphicDetailState {}

class InfoGraphicDetailLoaded extends InfoGraphicDetailState {
  final DocumentSnapshot record;

  const InfoGraphicDetailLoaded(this.record);

  @override
  List<Object> get props => <Object>[record];
}

class InfoGraphicDetailFailure extends InfoGraphicDetailState {
  final String error;

  const InfoGraphicDetailFailure({required this.error});

  @override
  String toString() => 'State InfoGraphicDetailFailure{error: $error}';

  @override
  List<Object> get props => <Object>[error];
}
