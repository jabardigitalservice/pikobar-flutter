part of 'CheckDistributionBloc.dart';

abstract class CheckDistributionState extends Equatable {
  const CheckDistributionState();

  @override
  List<Object> get props => [];
}

class CheckDistributionInitial extends CheckDistributionState {
  @override
  List<Object> get props => [];
}

class CheckDistributionLoading extends CheckDistributionState {}
class CheckDistributionLoadingIsOther extends CheckDistributionState {}


class CheckDistributionLoaded extends CheckDistributionState {
  final CheckDistributionModel record;

  const CheckDistributionLoaded({@required this.record});

  @override
  List<Object> get props => [record];

  @override
  String toString() => 'CheckDistributionLoaded { record: $record }';
}

class CheckDistributionFailure extends CheckDistributionState {
  final String error;

  CheckDistributionFailure({this.error});

  @override
  String toString() => 'State CheckDistributionFailure{error: $error}';

  @override
  List<Object> get props => [error];
}
