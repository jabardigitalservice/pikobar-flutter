import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';

abstract class BannersState extends Equatable {
  const BannersState();
}

class InitialBannersState extends BannersState {
  @override
  List<Object> get props => <Object>[];
}

class BannersLoading extends BannersState {

  @override
  String toString() => 'BannersLoading';

  @override
  List<Object> get props => <Object>[];
}

class BannersLoaded extends BannersState {

  final List<BannerModel> records;

  const BannersLoaded({this.records});

  @override
  String toString() => 'BannersLoaded';

  @override
  List<Object> get props => <Object>[records];
}
