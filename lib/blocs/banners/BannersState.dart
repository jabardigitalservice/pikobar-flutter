import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';

abstract class BannersState extends Equatable {
  const BannersState();

  @override
  List<Object> get props => <Object>[];
}

class InitialBannersState extends BannersState {}

class BannersLoading extends BannersState {}

class BannersLoaded extends BannersState {

  final List<BannerModel> records;

  const BannersLoaded({this.records});

  @override
  List<Object> get props => <Object>[records];
}
