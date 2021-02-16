part of 'DailyReportBloc.dart';

abstract class DailyReportState extends Equatable {
  const DailyReportState([List props = const <dynamic>[]]);
}

class DailyReportInitial extends DailyReportState {
  @override
  List<Object> get props => [];
}

class DailyReportLoading extends DailyReportState {
  @override
  List<Object> get props => [];
}

class DailyReportSaved extends DailyReportState {
  final dynamic successMessage;
  const DailyReportSaved(this.successMessage);
  @override
  List<Object> get props => [];
}

class DailyReportFailed extends DailyReportState {
  final String error;

  const DailyReportFailed({@required this.error}) : assert(error != null);

  @override
  List<Object> get props => [];
}
