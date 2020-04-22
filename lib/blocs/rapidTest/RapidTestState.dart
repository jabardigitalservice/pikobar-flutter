
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/RapidTestModel.dart';

abstract class RapidTestState extends Equatable {
  const RapidTestState();

  @override
  List<Object> get props => [];
}

class RapidTestInitial extends RapidTestState {
  @override
  List<Object> get props => [];
}

class RapidTestLoading extends RapidTestState {}

class RapidTestLoaded extends RapidTestState {
  final RapidTestModel record;

  const RapidTestLoaded({@required this.record});

  @override
  List<Object> get props => [record];

  @override
  String toString() => 'RapidTestLoaded { record: $record }';
}

class RapidTestFailure extends RapidTestState {
  final String error;

  RapidTestFailure({this.error});

  @override
  String toString() {
    return 'State RapidTestFailure{error: $error}';
  }

  @override
  List<Object> get props => [error];
}