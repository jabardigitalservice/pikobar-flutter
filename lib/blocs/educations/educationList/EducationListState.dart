import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';

abstract class EducationListState extends Equatable {
  const EducationListState([List props = const <dynamic>[]]);
}

class InitialEducationListState extends EducationListState {
  @override
  List<Object> get props => [];
}

class EducationLisLoading extends EducationListState {
  @override
  List<Object> get props => [];
}

class EducationListLoaded extends EducationListState {
  final List<EducationModel> educationList;

  EducationListLoaded(this.educationList);

  @override
  List<Object> get props => [educationList];
}
