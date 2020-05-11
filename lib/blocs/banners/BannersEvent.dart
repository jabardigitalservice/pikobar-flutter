import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';

abstract class BannersEvent extends Equatable {
  const BannersEvent([List props = const <dynamic>[]]);
}

class BannersLoad extends BannersEvent {
  @override
  String toString() => 'BannersLoad';

  @override
  List<Object> get props => [];
}

class BannersUpdate extends BannersEvent {
  final List<BannerModel> records;

  const BannersUpdate(this.records);

  @override
  String toString() => 'BannersUpdate';

  @override
  List<Object> get props => [records];
}


