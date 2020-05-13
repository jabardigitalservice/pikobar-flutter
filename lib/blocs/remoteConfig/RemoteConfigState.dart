import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigState extends Equatable {
  const RemoteConfigState([List props = const <dynamic>[]]);
}

class InitialRemoteConfigState extends RemoteConfigState {
  @override
  List<Object> get props => [];
}

class RemoteConfigLoading extends RemoteConfigState {
  @override
  String toString() {
    return 'State RemoteConfigLoading';
  }

  @override
  List<Object> get props => [];
}

class RemoteConfigLoaded extends RemoteConfigState {
  final RemoteConfig remoteConfig;

  RemoteConfigLoaded(this.remoteConfig) : super([remoteConfig]);

  @override
  String toString() {
    return 'State RemoteConfigLoaded';
  }

  @override
  List<Object> get props => [remoteConfig];
}

