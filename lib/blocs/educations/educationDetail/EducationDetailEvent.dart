import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class EducationDetailEvent extends Equatable {
  const EducationDetailEvent([List props = const <dynamic>[]]);
}

class EducationDetailLoad extends EducationDetailEvent {
  final String educationCollection;
  final String educationId;

  EducationDetailLoad(
      {@required this.educationCollection, @required this.educationId});

  @override
  List<Object> get props => [educationCollection, educationId];
}
