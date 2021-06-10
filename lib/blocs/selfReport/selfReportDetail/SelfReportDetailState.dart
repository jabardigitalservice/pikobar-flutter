part of 'SelfReportDetailBloc.dart';

abstract class SelfReportDetailState extends Equatable {
  const SelfReportDetailState();

  @override
  List<Object> get props => <Object>[];
}

class SelfReportDetailInitial extends SelfReportDetailState {}

class SelfReportDetailLoading extends SelfReportDetailState {}

class SelfReportDetailLoaded extends SelfReportDetailState {
  final DocumentSnapshot documentSnapshot;

  const SelfReportDetailLoaded({@required this.documentSnapshot});

  @override
  List<Object> get props => <Object>[documentSnapshot];
}

class SelfReportDetailFailure extends SelfReportDetailState {
  final String error;

  const SelfReportDetailFailure({@required this.error});

  @override
  List<Object> get props => <Object>[error];
}
