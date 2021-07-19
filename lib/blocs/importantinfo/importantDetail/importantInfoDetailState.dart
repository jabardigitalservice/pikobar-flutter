import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';

abstract class ImportantInfoDetailState extends Equatable {
  const ImportantInfoDetailState();

  @override
  List<Object> get props => <Object>[];
}

class InitialImportantInfoDetailState extends ImportantInfoDetailState {}

class ImportantInfoDetailLoading extends ImportantInfoDetailState {}

class ImportantInfoDetailLoaded extends ImportantInfoDetailState {
  final ImportantInfoModel record;

  const ImportantInfoDetailLoaded(this.record);

  @override
  List<Object> get props => <Object>[record];

  @override
  String toString() => 'ImportantInfoDetailLoaded { record: $record }';
}