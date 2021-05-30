import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';

abstract class EducationListEvent extends Equatable {
  const EducationListEvent();
}

class EducationListLoad extends EducationListEvent {
  final String educationCollection;

  const EducationListLoad(this.educationCollection);

  @override
  String toString() => 'Event EducationListLoad $educationCollection';

  @override
  List<Object> get props => <Object>[educationCollection];
}

class EducationListUpdate extends EducationListEvent {
  final List<EducationModel> educationList;

  const EducationListUpdate(this.educationList);

  @override
  String toString() => 'Event EducationListUpdate';

  @override
  List<Object> get props => <Object>[educationList];
}
