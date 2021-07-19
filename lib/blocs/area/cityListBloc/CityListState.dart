import 'package:equatable/equatable.dart';

abstract class CityListState extends Equatable {
  const CityListState();

  @override
  List<Object> get props => <Object>[];
}

class InitialCityListState extends CityListState {
  @override
  List<Object> get props => <Object>[];
}

class CityListLoading extends CityListState {
  @override
  List<Object> get props => <Object>[];
}

class CityListLoaded extends CityListState {
  final List<dynamic> cityList;

  CityListLoaded(this.cityList);

  @override
  List<Object> get props => <Object>[cityList];
}
