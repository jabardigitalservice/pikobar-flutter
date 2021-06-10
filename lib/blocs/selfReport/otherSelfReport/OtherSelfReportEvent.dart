part of 'OtherSelfReportBloc.dart';

abstract class OtherSelfReportEvent extends Equatable {
  const OtherSelfReportEvent();

  @override
  List<Object> get props => <Object>[];
}

class OtherSelfReportLoad extends OtherSelfReportEvent {}

class OtherSelfReportUpdated extends OtherSelfReportEvent {
  final QuerySnapshot selfReportList;

  const OtherSelfReportUpdated(this.selfReportList);

  @override
  List<Object> get props => <Object>[selfReportList];
}



