import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent([List props = const <dynamic>[]]);
}

class StatisticsLoad extends StatisticsEvent {

  StatisticsLoad();

  @override
  String toString() {
    return 'Event StatisticsLoad';
  }

  @override
  List<Object> get props => [];

}

class StatisticsUpdate extends StatisticsEvent {

  final DocumentSnapshot snapshot;

  StatisticsUpdate(this.snapshot);

  @override
  String toString() => 'Event StatisticsUpdate';

  @override
  List<Object> get props => [snapshot];
}
