part of 'DailyChartBloc.dart';

abstract class DailyChartEvent extends Equatable {
  const DailyChartEvent();

  @override
  List<Object> get props => [];
}

class LoadDailyChart extends DailyChartEvent {
  final String cityId;

  const LoadDailyChart({@required this.cityId});

  @override
  List<Object> get props => [cityId];
}
