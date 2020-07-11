import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';

abstract class EducationDetailState extends Equatable {
  const EducationDetailState([List props = const <dynamic>[]]);
}

class InitialEducationDetailState extends EducationDetailState {
  @override
  List<Object> get props => [];
}

class EducationDetailLoading extends EducationDetailState {
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class EducationDetailLoaded extends EducationDetailState {
  final EducationModel record;

  const EducationDetailLoaded(this.record);

  @override
  List<Object> get props => [record];

  @override
  String toString() => 'EducationDetailLoaded { record: $record }';
}

class EducationDetailFailure extends EducationDetailState {
  final String error;

  EducationDetailFailure({this.error});

  @override
  String toString() {
    return 'State EducationDetailFailure{error: $error}';
  }

  @override
  List<Object> get props => [error];
}