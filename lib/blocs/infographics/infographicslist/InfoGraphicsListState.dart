import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class InfoGraphicsListState extends Equatable {
  const InfoGraphicsListState([List props = const <dynamic>[]]);
}

class InitialInfoGraphicsListState extends InfoGraphicsListState {
  @override
  List<Object> get props => [];
}

class InfoGraphicsListLoading extends InfoGraphicsListState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InfoGraphicsListLoaded extends InfoGraphicsListState {
  final List<DocumentSnapshot> infoGraphicsList;

  InfoGraphicsListLoaded(this.infoGraphicsList);

  @override
  List<Object> get props => [infoGraphicsList];

  @override
  String toString() => 'InfoGraphicsLoaded';
}
