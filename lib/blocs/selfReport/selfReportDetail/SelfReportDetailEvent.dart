part of 'SelfReportDetailBloc.dart';

abstract class SelfReportDetailEvent extends Equatable {
  const SelfReportDetailEvent([List props = const <dynamic>[]]);
}

class SelfReportDetailLoad extends SelfReportDetailEvent {
  final String selfReportId;

  SelfReportDetailLoad({@required this.selfReportId});

  @override
  List<Object> get props => [];
}
