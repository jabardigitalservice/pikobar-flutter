part of 'DailyChartBloc.dart';

abstract class DailyChartEvent extends Equatable {
  const DailyChartEvent();

  @override
  List<Object> get props => [];
}

class LoadDailyChart extends DailyChartEvent {
  final Position cityId;
  final dynamic listCityId;

  const LoadDailyChart({@required this.cityId, @required this.listCityId});

  @override
  List<Object> get props => [cityId, listCityId];
}
