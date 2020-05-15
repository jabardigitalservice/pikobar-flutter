import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';

abstract class importantInfoDetailState extends Equatable {
  const importantInfoDetailState([List props = const <dynamic>[]]);
}

class InitialImportantInfoDetailState extends importantInfoDetailState {
  @override
  List<Object> get props => [];
}

class ImportantInfoDetailLoading extends importantInfoDetailState {
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class ImportantInfoDetailLoaded extends importantInfoDetailState {
  final ImportantinfoModel record;

  const ImportantInfoDetailLoaded(this.record);

  @override
  List<Object> get props => [record];

  @override
  String toString() => 'ImportantInfoDetailLoaded { record: $record }';
}