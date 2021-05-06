import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class RapidTestAntigenState extends Equatable {
  const RapidTestAntigenState([List props = const <dynamic>[]]);
}

class InitialRapidTestAntigenState extends RapidTestAntigenState {
  @override
  List<Object> get props => [];
}

class RapidTestAntigenLoading extends RapidTestAntigenState {
  @override
  String toString() {
    return 'State RapidTestAntigenLoading';
  }

  @override
  List<Object> get props => [];
}

class RapidTestAntigenLoaded extends RapidTestAntigenState {
  final DocumentSnapshot snapshot;

  RapidTestAntigenLoaded({this.snapshot}) : super([snapshot]);

  @override
  String toString() {
    return 'State RapidTestAntigenLoaded';
  }

  @override
  List<Object> get props => [snapshot];
}
