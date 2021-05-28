import 'package:equatable/equatable.dart';

abstract class SubCityListEvent extends Equatable {
  const SubCityListEvent([List props = const <dynamic>[]]);
}

class SubCityListLoad extends SubCityListEvent {
  @override
  String toString() => 'Event SubCityListLoad ';

  @override
  List<Object> get props => [];
}

class SubCityListUpdate extends SubCityListEvent {
  final List<dynamic> subCityList;

  SubCityListUpdate(this.subCityList);

  @override
  String toString() => 'Event SubCityListUpdate';

  @override
  List<Object> get props => [subCityList];
}
