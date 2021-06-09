part of 'SelfReportReminderBloc.dart';

abstract class SelfReportReminderState extends Equatable {
  const SelfReportReminderState();

  @override
  List<Object> get props => <Object>[];
}

class SelfReportReminderInitial extends SelfReportReminderState {}

class SelfReportReminderLoading extends SelfReportReminderState {}

class SelfReportIsreminderSaved extends SelfReportReminderState {}

class SelfReportRecurrenceReportSaved extends SelfReportReminderState {}

class SelfReportIsReminderLoaded extends SelfReportReminderState {
  final DocumentSnapshot querySnapshot;

  const SelfReportIsReminderLoaded({@required this.querySnapshot});

  @override
  List<Object> get props => <Object>[querySnapshot];
}

class SelfReportReminderFailure extends SelfReportReminderState {
  final String error;

  const SelfReportReminderFailure({@required this.error});

  @override
  List<Object> get props => <Object>[error];
}
