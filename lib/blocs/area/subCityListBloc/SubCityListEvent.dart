import 'package:equatable/equatable.dart';

abstract class SubCityListEvent extends Equatable {
  const SubCityListEvent();

  @override
  List<Object> get props => <Object>[];
}

class SubCityListLoad extends SubCityListEvent {}

class SubCityListUpdate extends SubCityListEvent {
  final List<dynamic> subCityList;

  SubCityListUpdate(this.subCityList);

  @override
  String toString() => 'Event SubCityListUpdate';

  @override
  List<Object> get props => <Object>[subCityList];
}
