part of 'SelfReportDetailBloc.dart';

abstract class SelfReportDetailEvent extends Equatable {
  const SelfReportDetailEvent();
}

class SelfReportDetailLoad extends SelfReportDetailEvent {
  final String selfReportId, otherUid;

  SelfReportDetailLoad({@required this.selfReportId, this.otherUid});

  @override
  List<Object> get props => [selfReportId, otherUid];
}
