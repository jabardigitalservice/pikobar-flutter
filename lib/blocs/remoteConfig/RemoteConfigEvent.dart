import 'package:equatable/equatable.dart';

abstract class RemoteConfigEvent extends Equatable {
  const RemoteConfigEvent([List props = const <dynamic>[]]);
}

class RemoteConfigLoad extends RemoteConfigEvent {

  RemoteConfigLoad();

  @override
  String toString() {
    return 'Event RemoteConfigLoad';
  }

  @override
  List<Object> get props => [];

}

