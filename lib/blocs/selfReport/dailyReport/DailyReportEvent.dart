part of 'DailyReportBloc.dart';

abstract class DailyReportEvent extends Equatable {
  const DailyReportEvent([List props = const <dynamic>[]]);
}

class DailyReportSave extends DailyReportEvent {

  final DailyReportModel dailyReportModel;

  DailyReportSave(this.dailyReportModel):assert(dailyReportModel != null);

  @override
  List<Object> get props => [dailyReportModel];
}
