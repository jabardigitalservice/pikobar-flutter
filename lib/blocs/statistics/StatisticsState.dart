import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => <Object>[];
}

class InitialStatisticsState extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final DocumentSnapshot snapshot;

  const StatisticsLoaded({this.snapshot});

  @override
  List<Object> get props => <Object>[snapshot];
}
