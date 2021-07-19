import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class RapidTestAntigenEvent extends Equatable {
  const RapidTestAntigenEvent([List props = const <dynamic>[]]);
}

class RapidTestAntigenLoad extends RapidTestAntigenEvent {
  RapidTestAntigenLoad();

  @override
  String toString() {
    return 'Event RapidTestAntigenLoad';
  }

  @override
  List<Object> get props => [];
}

class RapidTestAntigenUpdate extends RapidTestAntigenEvent {
  final DocumentSnapshot snapshot;

  RapidTestAntigenUpdate(this.snapshot);

  @override
  String toString() => 'Event RapidTestAntigenUpdate';

  @override
  List<Object> get props => [snapshot];
}
