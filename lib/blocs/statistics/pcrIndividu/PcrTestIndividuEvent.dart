import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PcrTestIndividuEvent extends Equatable {
  const PcrTestIndividuEvent([List props = const <dynamic>[]]);
}

class PcrTestIndividuLoad extends PcrTestIndividuEvent {
  PcrTestIndividuLoad();

  @override
  String toString() {
    return 'Event PcrTestIndividuLoad';
  }

  @override
  List<Object> get props => [];
}

class PcrTestIndividuUpdate extends PcrTestIndividuEvent {
  final DocumentSnapshot snapshot;

  PcrTestIndividuUpdate(this.snapshot);

  @override
  String toString() => 'Event PcrTestIndividuUpdate';

  @override
  List<Object> get props => [snapshot];
}
