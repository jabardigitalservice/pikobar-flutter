import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/CityModel.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

import './Bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  StreamSubscription<Object> _subscription;

  ProfileBloc({
    @required this.profileRepository,
  })  : assert(profileRepository != null, 'profileRepository must not be null'),
        super(ProfileUninitialized());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is CityLoad) {
      yield CityLoading();
      try {
        CityModel record = await profileRepository.getCityList();
        yield CityLoaded(record: record);
      } on Exception catch (e) {
        yield ProfileFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
    if (event is Save) {
      yield ProfileLoading();
      try {
        await profileRepository.saveToCollection(
            event.id,
            event.phoneNumber,
            event.gender,
            event.address,
            event.cityId,
            event.provinceId,
            event.name,
            event.nik,
            event.birthdate,
            event.latLng);
        yield ProfileSaved();
      } on Exception catch (e) {
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
      } on Exception catch (e) {
        yield ProfileFailure(error: e.toString());
      }
    }

    if (event is ConfirmOTP) {
      yield ProfileLoading();
      try {
        await profileRepository.signInWithPhoneNumber(
            event.smsCode,
            event.verificationID,
            event.id,
            event.phoneNumber,
            event.gender,
            event.address,
            event.cityId,
            event.provinceId,
            event.name,
            event.nik,
            event.birthdate,
            event.latLng);
        yield ProfileVerified();
      } on Exception catch (e) {
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

    if (event is ProfileLoad) {
      yield* _loadSelfReportListToState(event.uid);
    } else if (event is ProfileUpdated) {
      yield* _selfReportListToState(event);
    }
  }

  Stream<ProfileState> _loadSelfReportListToState(String otherUID) async* {
    yield ProfileLoading();
    await _subscription?.cancel();
    _subscription = profileRepository.getProfile(otherUID).listen((event) {
      add(ProfileUpdated(event));
    });
  }

  Stream<ProfileState> _selfReportListToState(ProfileUpdated event) async* {
    yield ProfileLoaded(profile: event.profile);
  }
}
