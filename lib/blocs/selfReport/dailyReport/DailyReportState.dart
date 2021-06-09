part of 'DailyReportBloc.dart';

abstract class DailyReportState extends Equatable {
  const DailyReportState();

  @override
  List<Object> get props => <Object>[];
}

class DailyReportInitial extends DailyReportState {}

class DailyReportLoading extends DailyReportState {}

class DailyReportSaved extends DailyReportState {
  final dynamic successMessage;

  const DailyReportSaved(this.successMessage);

  @override
  List<Object> get props => <Object>[successMessage];
}

class DailyReportFailed extends DailyReportState {
  final String error;

  const DailyReportFailed({@required this.error});

  @override
  List<Object> get props => <Object>[error];
}
