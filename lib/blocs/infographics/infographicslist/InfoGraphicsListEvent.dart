import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class InfoGraphicsListEvent extends Equatable {
  const InfoGraphicsListEvent();
}

class InfoGraphicsListLoad extends InfoGraphicsListEvent {
  final int limit;
  final String infoGraphicsCollection;

  const InfoGraphicsListLoad(
      {required this.limit, required this.infoGraphicsCollection});

  @override
  List<Object> get props => <Object>[limit, infoGraphicsCollection];
}

class InfoGraphicsListUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsList;

  const InfoGraphicsListUpdate(this.infoGraphicsList);

  @override
  List<Object> get props => <Object>[infoGraphicsList];
}

class InfoGraphicsListJabarLoad extends InfoGraphicsListEvent {
  final int limit;
  final String infoGraphicsCollection;

  const InfoGraphicsListJabarLoad(
      {required this.limit, required this.infoGraphicsCollection});

  @override
  List<Object> get props => <Object>[limit];
}

class InfoGraphicsListJabarUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsListJabar;

  const InfoGraphicsListJabarUpdate(this.infoGraphicsListJabar);

  @override
  List<Object> get props => <Object>[infoGraphicsListJabar];
}

class InfoGraphicsListPusatLoad extends InfoGraphicsListEvent {
  final int limit;
  final String infoGraphicsCollection;

  const InfoGraphicsListPusatLoad(
      {required this.limit, required this.infoGraphicsCollection});

  @override
  List<Object> get props => <Object>[limit];
}

class InfoGraphicsListPusatUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsListPusat;

  const InfoGraphicsListPusatUpdate(this.infoGraphicsListPusat);

  @override
  List<Object> get props => <Object>[infoGraphicsListPusat];
}

class InfoGraphicsListWHOLoad extends InfoGraphicsListEvent {
  final int limit;
  final String infoGraphicsCollection;

  const InfoGraphicsListWHOLoad(
      {required this.limit, required this.infoGraphicsCollection});

  @override
  List<Object> get props => <Object>[limit];
}

class InfoGraphicsListWHOUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsListWHO;

  const InfoGraphicsListWHOUpdate(this.infoGraphicsListWHO);

  @override
  List<Object> get props => <Object>[infoGraphicsListWHO];
}
