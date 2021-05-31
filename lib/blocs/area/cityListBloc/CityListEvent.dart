import 'package:equatable/equatable.dart';

abstract class CityListEvent extends Equatable {
  const CityListEvent();

  @override
  List<Object> get props => <Object>[];
}

class CityListLoad extends CityListEvent {}

class CityListUpdate extends CityListEvent {
  final List<dynamic> cityList;

  CityListUpdate(this.cityList);

  @override
  String toString() => 'Event CityListUpdate';

  @override
  List<Object> get props => <Object>[cityList];
}
