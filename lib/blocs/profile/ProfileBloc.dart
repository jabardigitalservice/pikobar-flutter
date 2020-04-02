import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';

import './Bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({
    @required this.profileRepository,
  }) : assert(profileRepository != null);

  @override
  ProfileState get initialState => ProfileUninitialized();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is Save) {
      yield ProfileLoading();
      try {
        await profileRepository.saveToCollection(event.id, event.phoneNumber);
        yield ProfileSaved();
      } catch (e) {
        yield ProfileFailure(error: e.toString());
      }
    }

    if (event is Verify) {
      yield ProfileLoading();
      try {
        await profileRepository.sendCodeToPhoneNumber(
            event.id,
            event.phoneNumber,
            event.verificationCompleted,
            event.verificationFailed,
            event.codeSent);

        yield ProfileWaiting();
      } catch (e) {
        yield ProfileFailure(error: e.toString());
      }
    }

    if (event is ConfirmOTP) {
      yield ProfileLoading();
      try {
        await profileRepository.signInWithPhoneNumber(
            event.smsCode, event.verificationID, event.id, event.phoneNumber);
        yield ProfileVerified();
      } catch (e) {
        yield ProfileFailure(error: e.toString());
      }
    }

    if (event is VerifyConfirm) {
      yield ProfileVerified();
    }

    if (event is VerifyFailed) {
      yield ProfileVerifiedFailed();
    }

    if (event is CodeSend) {
      yield ProfileOTPSent(verificationID: event.verificationID);
    }
  }
}
