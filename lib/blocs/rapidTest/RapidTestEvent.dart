import 'package:equatable/equatable.dart';

abstract class RapidTestEvent extends Equatable {
  const RapidTestEvent();

  @override
  List<Object> get props => <Object>[];
}

class RapidTestLoad extends RapidTestEvent {}
