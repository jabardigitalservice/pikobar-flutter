import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';

abstract class EducationDetailState extends Equatable {
  const EducationDetailState();

  @override
  List<Object> get props => <Object>[];
}

class InitialEducationDetailState extends EducationDetailState {}

class EducationDetailLoading extends EducationDetailState {}

class EducationDetailLoaded extends EducationDetailState {
  final EducationModel record;

  const EducationDetailLoaded(this.record);

  @override
  List<Object> get props => <Object>[record];
}

class EducationDetailFailure extends EducationDetailState {
  final String error;

  const EducationDetailFailure({required this.error});

  @override
  String toString() => 'State EducationDetailFailure{error: $error}';

  @override
  List<Object> get props => <Object>[error];
}
