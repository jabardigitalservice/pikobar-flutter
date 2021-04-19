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

class InfoGraphicsListJabarLoaded extends InfoGraphicsListState {
  final List<DocumentSnapshot> infoGraphicsListJabar;

  InfoGraphicsListJabarLoaded(this.infoGraphicsListJabar);

  @override
  List<Object> get props => [infoGraphicsListJabar];

  @override
  String toString() => 'InfoGraphicsListJabarLoaded';
}

class InfoGraphicsListPusatLoaded extends InfoGraphicsListState {
  final List<DocumentSnapshot> infoGraphicsListPusat;

  InfoGraphicsListPusatLoaded(this.infoGraphicsListPusat);

  @override
  List<Object> get props => [infoGraphicsListPusat];

  @override
  String toString() => 'InfoGraphicsListPusatLoaded';
}

class InfoGraphicsListWHOLoaded extends InfoGraphicsListState {
  final List<DocumentSnapshot> infoGraphicsListWHO;

  InfoGraphicsListWHOLoaded(this.infoGraphicsListWHO);

  @override
  List<Object> get props => [infoGraphicsListWHO];

  @override
  String toString() => 'InfoGraphicsListWHOLoaded';
}
