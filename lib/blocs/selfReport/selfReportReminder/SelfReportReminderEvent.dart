part of 'SelfReportReminderBloc.dart';

abstract class SelfReportReminderEvent extends Equatable {
  const SelfReportReminderEvent();

  @override
  // TODO: implement props
  List<Object> get props => <Object>[];
}

class SelfReportReminderListLoad extends SelfReportReminderEvent {}

@immutable
class SelfReportListUpdateReminder extends SelfReportReminderEvent {
  final bool isReminder;

  const SelfReportListUpdateReminder(this.isReminder);

  @override
  List<Object> get props => <Object>[isReminder];
}

class SelfReportUpdateRecurrenceReport extends SelfReportReminderEvent {
  final String recurrenceReport, otherUID;

  const SelfReportUpdateRecurrenceReport(this.recurrenceReport, this.otherUID);

  @override
  List<Object> get props => <Object>[recurrenceReport, otherUID];
}

class SelfReportReminderUpdated extends SelfReportReminderEvent {
  final DocumentSnapshot selfReportReminderList;

  const SelfReportReminderUpdated(this.selfReportReminderList);

  @override
  List<Object> get props => <Object> [selfReportReminderList];
}
