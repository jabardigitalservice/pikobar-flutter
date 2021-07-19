part of 'SelfReportListBloc.dart';

abstract class SelfReportListState extends Equatable {
  const SelfReportListState();

  @override
  List<Object> get props => <Object>[];
}

class SelfReportListInitial extends SelfReportListState {}

class SelfReportListLoading extends SelfReportListState {}

@immutable
class SelfReportListLoaded extends SelfReportListState {
  final QuerySnapshot querySnapshot;

  const SelfReportListLoaded({@required this.querySnapshot});

  @override
  List<Object> get props => <Object>[querySnapshot];
}

class SelfReportListFailure extends SelfReportListState {
  final String error;

  const SelfReportListFailure({@required this.error});

  @override
  List<Object> get props => <Object>[error];
}
