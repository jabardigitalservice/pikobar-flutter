part of 'zonation_cubit.dart';

abstract class ZonationState extends Equatable {
  const ZonationState();

  @override
  List<Object> get props => [];
}

class ZonationInitial extends ZonationState {
}

class ZonationLoading extends ZonationState {
}

class ZonationLoaded extends ZonationState {
  final CheckDistributionModel record;

  const ZonationLoaded({@required this.record});
}

class ZonationFailure extends ZonationState {
  final String error;

  const ZonationFailure(this.error);

  @override
  List<Object> get props => [error];
}


