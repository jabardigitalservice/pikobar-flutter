import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PcrTestState extends Equatable {
  const PcrTestState([List props = const <dynamic>[]]);
}

class InitialPcrTestState extends PcrTestState {
  @override
  List<Object> get props => [];
}

class PcrTestLoading extends PcrTestState {
  @override
  String toString() {
    return 'State PcrTestLoading';
  }

  @override
  List<Object> get props => [];
}

class PcrTestLoaded extends PcrTestState {
  final DocumentSnapshot snapshot;

  PcrTestLoaded({this.snapshot}) : super([snapshot]);

  @override
  String toString() {
    return 'State PcrTestLoaded';
  }

  @override
  List<Object> get props => [snapshot];
}
