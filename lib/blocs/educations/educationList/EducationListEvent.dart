import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';

abstract class EducationListEvent extends Equatable {
  const EducationListEvent();
}

class EducationListLoad extends EducationListEvent {
  final String educationCollection;
  final int limit;

  const EducationListLoad(this.educationCollection, {this.limit});

  @override
  List<Object> get props => <Object>[educationCollection];
}

class EducationListUpdate extends EducationListEvent {
  final List<EducationModel> educationList;

  const EducationListUpdate(this.educationList);

  @override
  List<Object> get props => <Object>[educationList];
}
