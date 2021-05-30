import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';

abstract class BannersEvent extends Equatable {
  const BannersEvent();
}

class BannersLoad extends BannersEvent {
  @override
  String toString() => 'BannersLoad';

  @override
  List<Object> get props => <Object>[];
}

class BannersUpdate extends BannersEvent {
  final List<BannerModel> records;

  const BannersUpdate(this.records);

  @override
  String toString() => 'BannersUpdate';

  @override
  List<Object> get props => <Object>[records];
}
