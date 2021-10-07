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
  final bool isSwabDoc;

  const SelfReportActivate(
      {@required this.date, @required this.type, @required this.isSwabDoc});

  @override
  List<Object> get props => [date, type, isSwabDoc];
}
