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
  final String cityId;
  final String subCityId;

  const LoadCheckDistribution(
      {this.lat,
      this.long,
      this.id,
      this.isOther,
      this.cityId,
      this.subCityId});

  @override
  List<Object> get props => [lat, long, id, isOther, cityId, subCityId];
}

class CheckDistributionLoad extends CheckDistributionEvent {
  final CheckDistributionModel record;

  const CheckDistributionLoad(this.record);

  @override
  List<Object> get props => [record];
}
