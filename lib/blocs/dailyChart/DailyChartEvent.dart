part of 'DailyChartBloc.dart';

abstract class DailyChartEvent extends Equatable {
  const DailyChartEvent();
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
  List<Object> get props => <Object>[cityId, listCityId];
}
