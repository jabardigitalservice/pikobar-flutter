import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/HealthStatus.dart';
import 'package:pikobar_flutter/models/CityModel.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

import './Bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  StreamSubscription _subscription;

  ProfileBloc({
    @required this.profileRepository,
  })  : assert(profileRepository != null),
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
      } catch (e) {
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

    if (event is ProfileLoad) {
      yield* _loadSelfReportListToState(event.uid);
    } else if (event is ProfileUpdated) {
      yield* _selfReportListToState(event);
    }
  }

  Stream<ProfileState> _loadSelfReportListToState(String otherUID) async* {
    yield ProfileLoading();
    _subscription?.cancel();

    _subscription = profileRepository.getProfile(otherUID).listen((event) {
      add(ProfileUpdated(event));
    });
  }

  Stream<ProfileState> _selfReportListToState(ProfileUpdated event) async* {
    final String getHealthStatus =
        await HealthStatusSharedPreference.getHealthStatus();
    final bool getIsHealthStatusChange =
        await HealthStatusSharedPreference.getIsHealthStatusChange() ?? false;
    if (getHealthStatus == null) {
      await HealthStatusSharedPreference.setHealthStatus(
          getField(event.profile, 'health_status'));
    } else if (getIsHealthStatusChange) {
      await HealthStatusSharedPreference.setHealthStatus(
          getField(event.profile, 'health_status'));
    } else if (getHealthStatus != getField(event.profile, 'health_status')) {
       await HealthStatusSharedPreference.setIsHealthStatusChange(true);
    }
    yield ProfileLoaded(event.profile);
  }
}
