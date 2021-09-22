part of 'SelfReportActivationBloc.dart';

enum SelfReportActivateType { ANTIGEN, PCR }

abstract class SelfReportActivationEvent extends Equatable {
  const SelfReportActivationEvent();

  @override
  List<Object> get props => [];
}

class SelfReportActivate extends SelfReportActivationEvent {
  final DateTime date;
  final SelfReportActivateType type;

  const SelfReportActivate({this.date, this.type});

  @override
  List<Object> get props => [date, type];
}
