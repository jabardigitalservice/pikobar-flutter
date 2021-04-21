part of 'CheckDistributionBloc.dart';

abstract class CheckDistributionEvent extends Equatable {
  const CheckDistributionEvent();

  @override
  List<Object> get props => [];
}

class LoadCheckDistribution extends CheckDistributionEvent {
  final dynamic lat;
  final dynamic long;
  final dynamic id;
  final bool isOther;

  const LoadCheckDistribution(
      {@required this.lat, @required this.long, this.id, this.isOther});

  @override
  List<Object> get props => [lat, long, id, isOther];
}

class CheckDistributionLoad extends CheckDistributionEvent {
  final CheckDistributionModel record;

  const CheckDistributionLoad(this.record);

  @override
  List<Object> get props => [record];
}
