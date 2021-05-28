import 'package:equatable/equatable.dart';

abstract class CityListState extends Equatable {
  const CityListState([List props = const <dynamic>[]]);
}

class InitialCityListState extends CityListState {
  @override
  List<Object> get props => [];
}

class CityListLoading extends CityListState {
  @override
  List<Object> get props => [];
}

class CityListLoaded extends CityListState {
  final List<dynamic> cityList;

  CityListLoaded(this.cityList);

  @override
  List<Object> get props => [cityList];
}
