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

@immutable
class SelfReportListLoaded extends SelfReportListState {
  final QuerySnapshot querySnapshot;

  SelfReportListLoaded({@required this.querySnapshot});

  @override
  List<Object> get props => [querySnapshot];
}

class SelfReportListFailure extends SelfReportListState {
  final String error;

  SelfReportListFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
