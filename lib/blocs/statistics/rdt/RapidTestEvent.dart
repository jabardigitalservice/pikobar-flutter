import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class RapidTestEvent extends Equatable {
  const RapidTestEvent([List props = const <dynamic>[]]);
}

class RapidTestLoad extends RapidTestEvent {

  RapidTestLoad();

  @override
  String toString() {
    return 'Event RapidTestLoad';
  }

  @override
  List<Object> get props => [];

}

class RapidTestUpdate extends RapidTestEvent {

  final DocumentSnapshot snapshot;

  RapidTestUpdate(this.snapshot);

  @override
  String toString() => 'Event RapidTestUpdate';

  @override
  List<Object> get props => [snapshot];
}
