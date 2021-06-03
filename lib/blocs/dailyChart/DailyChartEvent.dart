part of 'DailyChartBloc.dart';

abstract class DailyChartEvent extends Equatable {
  const DailyChartEvent();
  
  @override
  List<Object> get props => <Object>[];
}

class LoadDailyChart extends DailyChartEvent {
  const LoadDailyChart();

  @override
  List<Object> get props => <Object>[];
}
