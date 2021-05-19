import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class InfoGraphicsListEvent extends Equatable {
  const InfoGraphicsListEvent([List props = const <dynamic>[]]);
}

class InfoGraphicsListLoad extends InfoGraphicsListEvent {
  final int limit;
  final String infoGraphicsCollection;

  InfoGraphicsListLoad({this.limit, this.infoGraphicsCollection});

  @override
  List<Object> get props => [limit, infoGraphicsCollection];
}

class InfoGraphicsListUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsList;

  InfoGraphicsListUpdate(this.infoGraphicsList);

  @override
  List<Object> get props => [infoGraphicsList];
}

class InfoGraphicsListJabarLoad extends InfoGraphicsListEvent {
  final int limit;
  final String infoGraphicsCollection;

  InfoGraphicsListJabarLoad({this.limit, this.infoGraphicsCollection});

  @override
  List<Object> get props => [limit];
}

class InfoGraphicsListJabarUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsListJabar;

  InfoGraphicsListJabarUpdate(this.infoGraphicsListJabar);

  @override
  List<Object> get props => [infoGraphicsListJabar];
}

class InfoGraphicsListPusatLoad extends InfoGraphicsListEvent {
  final int limit;
  final String infoGraphicsCollection;

  InfoGraphicsListPusatLoad({this.limit, this.infoGraphicsCollection});

  @override
  List<Object> get props => [limit];
}

class InfoGraphicsListPusatUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsListPusat;

  InfoGraphicsListPusatUpdate(this.infoGraphicsListPusat);

  @override
  List<Object> get props => [infoGraphicsListPusat];
}

class InfoGraphicsListWHOLoad extends InfoGraphicsListEvent {
  final int limit;
  final String infoGraphicsCollection;

  InfoGraphicsListWHOLoad({this.limit, this.infoGraphicsCollection});

  @override
  List<Object> get props => [limit];
}

class InfoGraphicsListWHOUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsListWHO;

  InfoGraphicsListWHOUpdate(this.infoGraphicsListWHO);

  @override
  List<Object> get props => [infoGraphicsListWHO];
}
