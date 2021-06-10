import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigState extends Equatable {
  const RemoteConfigState();

  @override
  List<Object> get props => <Object>[];
}

class InitialRemoteConfigState extends RemoteConfigState {}

class RemoteConfigLoading extends RemoteConfigState {}

class RemoteConfigLoaded extends RemoteConfigState {
  final RemoteConfig remoteConfig;

  const RemoteConfigLoaded(this.remoteConfig);

  @override
  List<Object> get props => <Object>[remoteConfig];
}
