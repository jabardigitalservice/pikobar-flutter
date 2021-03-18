part of 'SelfReportListBloc.dart';

abstract class SelfReportListState extends Equatable {
  const SelfReportListState([List props = const <dynamic>[]]);
}

class SelfReportListInitial extends SelfReportListState {
  @override
  List<Object> get props => [];
}

class SelfReportListLoading extends SelfReportListState {
  @override
  List<Object> get props => [];
}

class SelfReportListLoaded extends SelfReportListState {
  final QuerySnapshot querySnapshot;
  final bool isHealthStatusChanged;

  SelfReportListLoaded(
      {@required this.querySnapshot, this.isHealthStatusChanged});

  @override
  List<Object> get props => [querySnapshot, isHealthStatusChanged];
}

class SelfReportListFailure extends SelfReportListState {
  final String error;

  SelfReportListFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
