import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/ProfileUid.dart';
import 'package:pikobar_flutter/models/UserModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

import './Bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;

  AuthenticationBloc({
    @required this.authRepository,
  })  : assert(authRepository != null, 'authRepositori must not be null'),
        super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    UserModel record;

    if (event is AppStarted) {
      bool hasToken = await authRepository.hasToken();
      if (hasToken) {
        yield AuthenticationLoading();
        record = await authRepository.getUserInfo();
        await ProfileUidSharedPreference.setProfileUid(record.uid);
        yield AuthenticationAuthenticated(record: record);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();

      try {
        record = await authRepository.getUserInfo(isApple: event.isApple);

        await authRepository.persistToken(
          record.uid,
        );
        await ProfileUidSharedPreference.setProfileUid(record.uid);
        yield AuthenticationAuthenticated(record: record);
      } on Exception catch (e) {
        yield AuthenticationFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await authRepository.signOut();
      yield AuthenticationUnauthenticated();
    }
  }
}
