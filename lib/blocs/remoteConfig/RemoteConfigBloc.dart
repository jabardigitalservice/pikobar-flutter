import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pikobar_flutter/repositories/RemoteConfigRepository.dart';
import './Bloc.dart';

class RemoteConfigBloc extends Bloc<RemoteConfigEvent, RemoteConfigState> {
  final RemoteConfigRepository _repository = RemoteConfigRepository();
  @override
  RemoteConfigState get initialState => InitialRemoteConfigState();

  @override
  Stream<RemoteConfigState> mapEventToState(
    RemoteConfigEvent event,
  ) async* {
    if (event is RemoteConfigLoad) {
      yield RemoteConfigLoading();

      RemoteConfig remoteConfig = await _repository.setupRemoteConfig();

      yield RemoteConfigLoaded(remoteConfig);
    }

  }
}
