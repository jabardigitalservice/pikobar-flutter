import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

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
  final List<NewsModel> imporntantinfoList;

  ImpoftantInfoListLoaded(this.imporntantinfoList);

  @override
  List<Object> get props => [imporntantinfoList];
}

