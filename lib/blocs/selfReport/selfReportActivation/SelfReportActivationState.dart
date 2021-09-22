part of 'SelfReportActivationBloc.dart';

abstract class SelfReportActivationState extends Equatable {
  const SelfReportActivationState();

  @override
  List<Object> get props => [];
}

class SelfReportActivationInitial extends SelfReportActivationState {}

class SelfReportActivationLoading extends SelfReportActivationState {}

class SelfReportActivationSuccess extends SelfReportActivationState {}

class SelfReportActivationFail extends SelfReportActivationState {}
