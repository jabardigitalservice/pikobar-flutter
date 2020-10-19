part of 'OtherSelfReportBloc.dart';


abstract class OtherSelfReportState extends Equatable {
  const OtherSelfReportState([List props = const <dynamic>[]]);
}

class OtherSelfReportInitial extends OtherSelfReportState {
  @override
  List<Object> get props => [];
}

class OtherSelfReportLoading extends OtherSelfReportState {
  @override
  List<Object> get props => [];
}



class OtherSelfReportLoaded extends OtherSelfReportState {
  final QuerySnapshot querySnapshot;


  OtherSelfReportLoaded({@required this.querySnapshot});

  @override
  List<Object> get props => [querySnapshot];
}


class OtherSelfReportFailure extends OtherSelfReportState {
  final String error;

  OtherSelfReportFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
