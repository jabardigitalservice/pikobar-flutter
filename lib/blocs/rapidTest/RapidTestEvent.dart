import 'package:equatable/equatable.dart';

abstract class RapidTestEvent extends Equatable {
  RapidTestEvent([List props = const <dynamic>[]]);
}

class RapidTestLoad extends RapidTestEvent {
  @override
  String toString() => 'RapidTestLoad';

  @override
  List<Object> get props => [];
}
