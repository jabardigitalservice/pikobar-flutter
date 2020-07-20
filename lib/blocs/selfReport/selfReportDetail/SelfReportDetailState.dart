part of 'SelfReportDetailBloc.dart';

abstract class SelfReportDetailState extends Equatable {
  const SelfReportDetailState([List props = const <dynamic>[]]);
}

class SelfReportDetailInitial extends SelfReportDetailState {
  @override
  List<Object> get props => [];
}

class SelfReportDetailLoading extends SelfReportDetailState {
  @override
  List<Object> get props => [];
}

class SelfReportDetailLoaded extends SelfReportDetailState {
  final DocumentSnapshot documentSnapshot;

  SelfReportDetailLoaded({@required this.documentSnapshot});

  @override
  List<Object> get props => [documentSnapshot];
}

class SelfReportDetailFailure extends SelfReportDetailState {
  final String error;

  SelfReportDetailFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
