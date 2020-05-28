import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';

abstract class BannersState extends Equatable {
  const BannersState([List props = const <dynamic>[]]);
}

class InitialBannersState extends BannersState {
  @override
  List<Object> get props => [];
}

class BannersLoading extends BannersState {

  @override
  String toString() => 'BannersLoading';

  @override
  List<Object> get props => [];
}

class BannersLoaded extends BannersState {

  final List<BannerModel> records;

  BannersLoaded({this.records});

  @override
  String toString() => 'BannersLoaded';

  @override
  List<Object> get props => [records];
}
