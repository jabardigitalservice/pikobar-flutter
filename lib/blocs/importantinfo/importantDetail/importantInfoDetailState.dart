import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';

// ignore: camel_case_types
abstract class importantInfoDetailState extends Equatable {
  const importantInfoDetailState();

  List<Object> get props => <Object>[];
}

class InitialImportantInfoDetailState extends importantInfoDetailState {}

class ImportantInfoDetailLoading extends importantInfoDetailState {}

class ImportantInfoDetailLoaded extends importantInfoDetailState {
  final ImportantInfoModel record;

  const ImportantInfoDetailLoaded(this.record);

  @override
  List<Object> get props => <Object>[record];

  @override
  String toString() => 'ImportantInfoDetailLoaded { record: $record }';
}