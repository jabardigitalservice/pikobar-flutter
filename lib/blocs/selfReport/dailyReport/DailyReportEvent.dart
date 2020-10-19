part of 'DailyReportBloc.dart';

abstract class DailyReportEvent extends Equatable {
  const DailyReportEvent([List props = const <dynamic>[]]);
}

class DailyReportSave extends DailyReportEvent {

  final DailyReportModel dailyReportModel;
  final String otherUID;

  DailyReportSave(this.dailyReportModel,{this.otherUID}):assert(dailyReportModel != null);

  @override
  List<Object> get props => [dailyReportModel];
}
