import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

abstract class ImportantInfoListState extends Equatable {
  const ImportantInfoListState();

  @override
  List<Object> get props => <Object>[];
}

class InitialImportantInfoListState extends ImportantInfoListState {}

class ImportantInfoListLoading extends ImportantInfoListState {}

class ImportantInfoListLoaded extends ImportantInfoListState {
  final List<NewsModel> importantInfoList;

  ImportantInfoListLoaded(this.importantInfoList);

  @override
  List<Object> get props => <Object>[importantInfoList];
}

