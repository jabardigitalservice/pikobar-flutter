part of 'CheckDistributionBloc.dart';

abstract class CheckDistributionState extends Equatable {
  const CheckDistributionState();

  @override
  List<Object> get props => <Object>[];
}

class CheckDistributionInitial extends CheckDistributionState {}

class CheckDistributionLoading extends CheckDistributionState {}

class CheckDistributionLoadingIsOther extends CheckDistributionState {}

class CheckDistributionLoaded extends CheckDistributionState {
  final CheckDistributionModel record;

  const CheckDistributionLoaded({required this.record});

  @override
  List<Object> get props => <Object>[record];
}

class CheckDistributionFailure extends CheckDistributionState {
  final String error;

  CheckDistributionFailure({required this.error});

  @override
  String toString() => 'State CheckDistributionFailure{error: $error}';

  @override
  List<Object> get props => <Object>[error];
}
