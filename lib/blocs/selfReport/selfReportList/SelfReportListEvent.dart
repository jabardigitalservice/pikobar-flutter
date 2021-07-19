part of 'SelfReportListBloc.dart';

abstract class SelfReportListEvent extends Equatable {
  const SelfReportListEvent();
}

class SelfReportListLoad extends SelfReportListEvent {
  final String otherUID, recurrenceReport;

  const SelfReportListLoad({this.otherUID, this.recurrenceReport});

  @override
  List<Object> get props => <Object>[otherUID, recurrenceReport];
}

class SelfReportListUpdated extends SelfReportListEvent {
  final QuerySnapshot selfReportList;

  const SelfReportListUpdated(this.selfReportList);

  @override
  List<Object> get props => <Object>[selfReportList];
}
