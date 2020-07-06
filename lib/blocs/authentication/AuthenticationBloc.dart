import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/UserModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';

import './Bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;

  AuthenticationBloc({
    @required this.authRepository,
  }) : assert(authRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    UserModel record;

    if (event is AppStarted) {
      final bool hasToken = await authRepository.hasToken();
      if (hasToken) {
        yield AuthenticationLoading();
        record = await authRepository.getUserInfo();
        yield AuthenticationAuthenticated(record: record);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();

      record = await authRepository.getUserInfo();

      try {
        await authRepository.persistToken(
          record.uid,
        );
        yield AuthenticationAuthenticated(record: record);
      } catch (e) {
        yield AuthenticationFailure(error: e.toString());
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await authRepository.signOut();
      yield AuthenticationUnauthenticated();
    }
  }
}
