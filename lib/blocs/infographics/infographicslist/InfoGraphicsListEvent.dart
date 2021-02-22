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
  List<Object> get props => [limit];
}

class InfoGraphicsListUpdate extends InfoGraphicsListEvent {
  final List<DocumentSnapshot> infoGraphicsList;

  InfoGraphicsListUpdate(this.infoGraphicsList);

  @override
  List<Object> get props => [infoGraphicsList];
}

