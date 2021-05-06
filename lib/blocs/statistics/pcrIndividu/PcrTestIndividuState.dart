import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PcrTestIndividuState extends Equatable {
  const PcrTestIndividuState([List props = const <dynamic>[]]);
}

class InitialPcrTestIndividuState extends PcrTestIndividuState {
  @override
  List<Object> get props => [];
}

class PcrTestIndividuLoading extends PcrTestIndividuState {
  @override
  String toString() {
    return 'State PcrTestIndividuLoading';
  }

  @override
  List<Object> get props => [];
}

class PcrTestIndividuLoaded extends PcrTestIndividuState {
  final DocumentSnapshot snapshot;

  PcrTestIndividuLoaded({this.snapshot}) : super([snapshot]);

  @override
  String toString() {
    return 'State PcrTestIndividuLoaded';
  }

  @override
  List<Object> get props => [snapshot];
}
