part of 'CheckdistributionBloc.dart';

abstract class CheckdistributionEvent extends Equatable {
  const CheckdistributionEvent();

  @override
  List<Object> get props => [];
}

class LoadCheckDistribution extends CheckdistributionEvent {
  final lat;
  final long;
  final id;
  final bool isOther;

  const LoadCheckDistribution(
      {@required this.lat, @required this.long, this.id, this.isOther});

  @override
  List<Object> get props => [lat, long, id, isOther];
}

class CheckDistributionLoad extends CheckdistributionEvent {
  final CheckDistributionModel record;

  const CheckDistributionLoad(this.record);

  @override
  List<Object> get props => [record];
}
