part of 'OtherSelfReportBloc.dart';

abstract class OtherSelfReportEvent extends Equatable {
  const OtherSelfReportEvent([List props = const <dynamic>[]]);
}

class OtherSelfReportLoad extends OtherSelfReportEvent {
  @override
  List<Object> get props => [];
}

class OtherSelfReportUpdated extends OtherSelfReportEvent {
  final QuerySnapshot selfReportList;

  const OtherSelfReportUpdated(this.selfReportList);

  @override
  List<Object> get props => [selfReportList];
}



