part of 'AddOtherSelfReportBloc.dart';

abstract class AddOtherSelfReportState extends Equatable {
  const AddOtherSelfReportState([List props = const <dynamic>[]]);
}

class AddOtherSelfReportInitial extends AddOtherSelfReportState {
  @override
  List<Object> get props => [];
}

class AddOtherSelfReportLoading extends AddOtherSelfReportState {
  @override
  List<Object> get props => [];
}

class AddOtherSelfReportSaved extends AddOtherSelfReportState {
  @override
  List<Object> get props => [];
}

class AddOtherSelfReportFailed extends AddOtherSelfReportState {
  final String error;

  AddOtherSelfReportFailed({@required this.error}):assert(error != null);

  @override
  List<Object> get props => [];
}