part of 'AddOtherSelfReportBloc.dart';

abstract class AddOtherSelfReportState extends Equatable {
  const AddOtherSelfReportState();

  @override
  List<Object> get props => <Object>[];
}

class AddOtherSelfReportInitial extends AddOtherSelfReportState {}

class AddOtherSelfReportLoading extends AddOtherSelfReportState {}

class AddOtherSelfReportSaved extends AddOtherSelfReportState {}

class AddOtherSelfReportFailed extends AddOtherSelfReportState {
  final String error;

  const AddOtherSelfReportFailed({@required this.error});

  @override
  List<Object> get props => <Object>[error];
}
