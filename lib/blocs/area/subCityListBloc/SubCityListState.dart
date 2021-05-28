import 'package:equatable/equatable.dart';

abstract class SubCityListState extends Equatable {
  const SubCityListState([List props = const <dynamic>[]]);
}

class InitialSubCityListState extends SubCityListState {
  @override
  List<Object> get props => [];
}

class SubCityListLoading extends SubCityListState {
  @override
  List<Object> get props => [];
}

class SubCityListLoaded extends SubCityListState {
  final List<dynamic> subcityList;

  SubCityListLoaded(this.subcityList);

  @override
  List<Object> get props => [subcityList];
}
