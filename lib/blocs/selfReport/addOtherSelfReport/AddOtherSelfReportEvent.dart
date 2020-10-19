part of 'AddOtherSelfReportBloc.dart';

abstract class AddOtherSelfReportEvent extends Equatable {
  const AddOtherSelfReportEvent([List props = const <dynamic>[]]);
}

class AddOtherSelfReportSave extends AddOtherSelfReportEvent {

  final AddOtherSelfReportModel dailyReportModel;

  AddOtherSelfReportSave(this.dailyReportModel):assert(dailyReportModel != null);

  @override
  List<Object> get props => [dailyReportModel];
}
