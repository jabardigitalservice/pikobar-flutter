import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
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
            event.id, event.phoneNumber);
        var getStatus = profileRepository.getStatus();
        if (getStatus['status'] == 'auto_verified') {
          yield ProfileVerified();
        } else if (getStatus['status'] == 'verification_failed') {
          yield ProfileVerifiedFailed();
        } else if (getStatus['status'] == 'code_sent') {
          yield ProfileOTPSent(verificationID: getStatus['verificationId']);
        }
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
  }
}
