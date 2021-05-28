import 'package:equatable/equatable.dart';

abstract class CityListEvent extends Equatable {
  const CityListEvent([List props = const <dynamic>[]]);
}

class CityListLoad extends CityListEvent {
  @override
  String toString() => 'Event CityListLoad ';

  @override
  List<Object> get props => [];
}

class CityListUpdate extends CityListEvent {
  final List<dynamic> cityList;

  CityListUpdate(this.cityList);

  @override
  String toString() => 'Event CityListUpdate';

  @override
  List<Object> get props => [cityList];
}
