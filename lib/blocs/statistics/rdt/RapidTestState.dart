import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class RapidTestState extends Equatable {
  const RapidTestState([List props = const <dynamic>[]]);
}

class InitialRapidTestState extends RapidTestState {
  @override
  List<Object> get props => [];
}

class RapidTestLoading extends RapidTestState {
  @override
  String toString() {
    return 'State RapidTestLoading';
  }

  @override
  List<Object> get props => [];
}

class RapidTestLoaded extends RapidTestState {
  final DocumentSnapshot snapshot;

  RapidTestLoaded({this.snapshot}) : super([snapshot]);

  @override
  String toString() {
    return 'State RapidTestLoaded';
  }

  @override
  List<Object> get props => [snapshot];
}
