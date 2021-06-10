part of 'OtherSelfReportBloc.dart';


abstract class OtherSelfReportState extends Equatable {
  const OtherSelfReportState();

  @override
  List<Object> get props => <Object>[];
}

class OtherSelfReportInitial extends OtherSelfReportState {}

class OtherSelfReportLoading extends OtherSelfReportState {}



class OtherSelfReportLoaded extends OtherSelfReportState {
  final QuerySnapshot querySnapshot;


  const OtherSelfReportLoaded({@required this.querySnapshot});

  @override
  List<Object> get props => <Object>[querySnapshot];
}


class OtherSelfReportFailure extends OtherSelfReportState {
  final String error;

  const OtherSelfReportFailure({@required this.error});

  @override
  List<Object> get props => <Object>[error];
}
