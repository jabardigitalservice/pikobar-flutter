import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => <Object>[];
}

class StatisticsLoad extends StatisticsEvent {}

class StatisticsUpdate extends StatisticsEvent {

  final DocumentSnapshot snapshot;

  const StatisticsUpdate(this.snapshot);

  @override
  List<Object> get props => <Object>[snapshot];
}
