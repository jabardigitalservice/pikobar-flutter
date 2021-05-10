part of 'DailyChartBloc.dart';

abstract class DailyChartState extends Equatable {
  const DailyChartState();

  @override
  List<Object> get props => [];
}

class DailyChartInitial extends DailyChartState {
  @override
  List<Object> get props => [];
}

class DailyChartLoading extends DailyChartState {}

class DailyChartLoadingIsOther extends DailyChartState {}

class DailyChartLoaded extends DailyChartState {
  final DailyChartModel record;

  const DailyChartLoaded({@required this.record});

  @override
  List<Object> get props => [record];

  @override
  String toString() => 'DailyChartLoaded { record: $record }';
}

class DailyChartFailure extends DailyChartState {
  final String error;

  DailyChartFailure({this.error});

  @override
  String toString() => 'State DailyChartFailure{error: $error}';

  @override
  List<Object> get props => [error];
}
