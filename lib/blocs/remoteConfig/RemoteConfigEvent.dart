import 'package:equatable/equatable.dart';

abstract class RemoteConfigEvent extends Equatable {
  const RemoteConfigEvent();

  @override
  List<Object> get props => <Object>[];
}

class RemoteConfigLoad extends RemoteConfigEvent {

  const RemoteConfigLoad();

  @override
  List<Object> get props => <Object>[];

}

