part of 'DailyReportBloc.dart';

abstract class DailyReportEvent extends Equatable {
  const DailyReportEvent([List props = const <dynamic>[]]);
}

class DailyReportSave extends DailyReportEvent {
  final DailyReportModel dailyReportModel;
  final String otherUID;
  final dynamic successMessage;

  const DailyReportSave(this.dailyReportModel,
      {this.otherUID, this.successMessage})
      : assert(dailyReportModel != null);

  @override
  List<Object> get props => [dailyReportModel];
}
