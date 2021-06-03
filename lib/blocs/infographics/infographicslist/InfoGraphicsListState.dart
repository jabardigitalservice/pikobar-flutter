import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class InfoGraphicsListState extends Equatable {
  const InfoGraphicsListState();

  @override
  List<Object> get props => <Object>[];
}

class InitialInfoGraphicsListState extends InfoGraphicsListState {}

class InfoGraphicsListLoading extends InfoGraphicsListState {}

class InfoGraphicsListLoaded extends InfoGraphicsListState {
  final List<DocumentSnapshot> infoGraphicsList;

  const InfoGraphicsListLoaded(this.infoGraphicsList);

  @override
  List<Object> get props => <Object>[infoGraphicsList];

  @override
  String toString() => 'InfoGraphicsLoaded';
}

class InfoGraphicsListJabarLoaded extends InfoGraphicsListState {
  final List<DocumentSnapshot> infoGraphicsListJabar;

  const InfoGraphicsListJabarLoaded(this.infoGraphicsListJabar);

  @override
  List<Object> get props => <Object>[infoGraphicsListJabar];

  @override
  String toString() => 'InfoGraphicsListJabarLoaded';
}

class InfoGraphicsListPusatLoaded extends InfoGraphicsListState {
  final List<DocumentSnapshot> infoGraphicsListPusat;

  const InfoGraphicsListPusatLoaded(this.infoGraphicsListPusat);

  @override
  List<Object> get props => <Object>[infoGraphicsListPusat];

  @override
  String toString() => 'InfoGraphicsListPusatLoaded';
}

class InfoGraphicsListWHOLoaded extends InfoGraphicsListState {
  final List<DocumentSnapshot> infoGraphicsListWHO;

  const InfoGraphicsListWHOLoaded(this.infoGraphicsListWHO);

  @override
  List<Object> get props => <Object>[infoGraphicsListWHO];

  @override
  String toString() => 'InfoGraphicsListWHOLoaded';
}
