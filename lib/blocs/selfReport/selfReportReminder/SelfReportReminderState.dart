part of 'SelfReportReminderBloc.dart';


abstract class SelfReportReminderState extends Equatable {
  const SelfReportReminderState([List props = const <dynamic>[]]);
}

class SelfReportReminderInitial extends SelfReportReminderState {
  @override
  List<Object> get props => [];
}



class SelfReportReminderLoading extends SelfReportReminderState {
  @override
  List<Object> get props => [];
}



class SelfReportIsreminderSaved extends SelfReportReminderState {
 

  @override
  List<Object> get props => [];
}

class SelfReportIsReminderLoaded extends SelfReportReminderState {
  final DocumentSnapshot querySnapshot;

  SelfReportIsReminderLoaded({@required this.querySnapshot});

  @override
  List<Object> get props => [querySnapshot];
}

class SelfReportReminderFailure extends SelfReportReminderState {
  final String error;

 SelfReportReminderFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
