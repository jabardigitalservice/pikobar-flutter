part of 'AddOtherSelfReportBloc.dart';

abstract class AddOtherSelfReportEvent extends Equatable {
  const AddOtherSelfReportEvent();

  @override
  List<Object> get props => <Object>[];
}

class AddOtherSelfReportSave extends AddOtherSelfReportEvent {
  final AddOtherSelfReportModel dailyReportModel;

  const AddOtherSelfReportSave(this.dailyReportModel)
      : assert(dailyReportModel != null, 'dailyReportModel must not be null');

  @override
  List<Object> get props => <Object>[dailyReportModel];
}
