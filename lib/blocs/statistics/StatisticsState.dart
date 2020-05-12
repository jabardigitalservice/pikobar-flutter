import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState([List props = const <dynamic>[]]);
}

class InitialStatisticsState extends StatisticsState {
  @override
  List<Object> get props => [];
}

class StatisticsLoading extends StatisticsState {
  @override
  String toString() {
    return 'State StatisticsLoading';
  }

  @override
  List<Object> get props => [];
}

class StatisticsLoaded extends StatisticsState {
  final DocumentSnapshot snapshot;

  StatisticsLoaded({this.snapshot}) : super([snapshot]);

  @override
  String toString() {
    return 'State StatisticsLoaded';
  }

  @override
  List<Object> get props => [snapshot];
}
