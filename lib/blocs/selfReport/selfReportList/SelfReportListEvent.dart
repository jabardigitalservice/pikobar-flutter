part of 'SelfReportListBloc.dart';

abstract class SelfReportListEvent extends Equatable {
  const SelfReportListEvent([List props = const <dynamic>[]]);
}

class SelfReportListLoad extends SelfReportListEvent {
  final String otherUID, recurrenceReport;
  SelfReportListLoad({this.otherUID, this.recurrenceReport});
  @override
  List<Object> get props => [];
}

class SelfReportListUpdated extends SelfReportListEvent {
  final QuerySnapshot selfReportList;
  final bool isHealthStatusChanged;

  const SelfReportListUpdated(this.selfReportList, this.isHealthStatusChanged);

  @override
  List<Object> get props => [selfReportList, isHealthStatusChanged];
}
