part of 'CheckdistributionBloc.dart';

abstract class CheckdistributionEvent extends Equatable {
  const CheckdistributionEvent();

    @override
  List<Object> get props => [];
}

class LoadCheckDistribution extends CheckdistributionEvent {
    final lat;
    final long;

  const LoadCheckDistribution({@required this.lat,@required this.long});

  @override
  List<Object> get props => [lat, long];
}

class CheckDistributionLoad extends CheckdistributionEvent {
  final CheckDistributionModel record;

  const CheckDistributionLoad(this.record);

  @override
  List<Object> get props => [record];
}