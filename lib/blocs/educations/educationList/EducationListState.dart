import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';

abstract class EducationListState extends Equatable {
  const EducationListState();

  @override
  List<Object> get props => <Object>[];
}

class InitialEducationListState extends EducationListState {}

class EducationLisLoading extends EducationListState {}

class EducationListLoaded extends EducationListState {
  final List<EducationModel> educationList;

  const EducationListLoaded(this.educationList);

  @override
  List<Object> get props => <Object>[educationList];
}
