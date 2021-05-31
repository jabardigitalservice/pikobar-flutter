import 'package:equatable/equatable.dart';

abstract class SubCityListState extends Equatable {
  const SubCityListState();

  @override
  List<Object> get props => <Object>[];
}

class InitialSubCityListState extends SubCityListState {
  @override
  List<Object> get props => <Object>[];
}

class SubCityListLoading extends SubCityListState {
  @override
  List<Object> get props => <Object>[];
}

class SubCityListLoaded extends SubCityListState {
  final List<dynamic> subcityList;

  SubCityListLoaded(this.subcityList);

  @override
  List<Object> get props => <Object>[subcityList];
}
