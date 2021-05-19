part of 'DailyChartBloc.dart';

abstract class DailyChartEvent extends Equatable {
  const DailyChartEvent();

  @override
  List<Object> get props => [];
}

class LoadDailyChart extends DailyChartEvent {
  final Position cityId;
  final dynamic listCityId;
  final String apiKey;

  const LoadDailyChart(
      {@required this.cityId,
      @required this.listCityId,
      @required this.apiKey});

  @override
  List<Object> get props => [cityId, listCityId];
}
