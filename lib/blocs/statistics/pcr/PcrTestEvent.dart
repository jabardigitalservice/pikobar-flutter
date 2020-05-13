import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PcrTestEvent extends Equatable {
  const PcrTestEvent([List props = const <dynamic>[]]);
}

class PcrTestLoad extends PcrTestEvent {

  PcrTestLoad();

  @override
  String toString() {
    return 'Event PcrTestLoad';
  }

  @override
  List<Object> get props => [];

}

class PcrTestUpdate extends PcrTestEvent {

  final DocumentSnapshot snapshot;

  PcrTestUpdate(this.snapshot);

  @override
  String toString() => 'Event PcrTestUpdate';

  @override
  List<Object> get props => [snapshot];
}