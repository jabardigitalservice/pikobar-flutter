import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';

abstract class ImportantInfoListState extends Equatable {
  const ImportantInfoListState([List props = const <dynamic>[]]);
}

class InitialImportantInfoListState extends ImportantInfoListState {
  @override
  List<Object> get props => [];
}

class ImportantInfoListLoading extends ImportantInfoListState {
  @override
  List<Object> get props => [];
}

class ImpoftantInfoListLoaded extends ImportantInfoListState {
  final List<ImportantInfoModel> imporntantinfoList;

  ImpoftantInfoListLoaded(this.imporntantinfoList);

  @override
  List<Object> get props => [imporntantinfoList];
}

