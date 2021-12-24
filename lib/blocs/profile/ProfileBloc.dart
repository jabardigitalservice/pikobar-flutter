import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/models/CityModel.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

import './Bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  late StreamSubscription<Object> _subscription;

  ProfileBloc({
    required this.profileRepository,
  }) : super(ProfileUninitialized()) {
    on<CityLoad>((event, emit) async {
      emit(CityLoading());
      try {
        CityModel record = await profileRepository.getCityList();
        emit(CityLoaded(record: record));
      } on Exception catch (e) {
        emit(ProfileFailure(
            error: CustomException.onConnectionException(e.toString())));
      }
    });

    on<Save>((event, emit) async {
      emit(ProfileLoading());
      try {
        await profileRepository.saveToCollection(
            event.id!,
            event.phoneNumber,
            event.gender,
            event.address,
            event.cityId,
            event.provinceId,
            event.name,
            event.nik,
            event.birthdate,
            event.latLng);
        emit(ProfileSaved());
      } on Exception catch (e) {
        emit(ProfileFailure(error: e.toString()));
      }
    });

    on<Verify>((event, emit) async {
      emit(ProfileLoading());
      try {
        await profileRepository.sendCodeToPhoneNumber(
            event.id!,
            event.phoneNumber,
            event.verificationCompleted!,
            event.verificationFailed!,
            event.codeSent!);
        emit(ProfileWaiting());
      } on Exception catch (e) {
        emit(ProfileFailure(error: e.toString()));
      }
    });

    on<ConfirmOTP>((event, emit) async {
      emit(ProfileLoading());
      try {
        await profileRepository.signInWithPhoneNumber(
            event.smsCode!,
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
        emit(ProfileVerified());
      } on Exception catch (e) {
        emit(ProfileFailure(error: e.toString()));
      }
    });

    on<VerifyConfirm>((event, emit) async {
      emit(ProfileVerified());
    });

    on<VerifyFailed>((event, emit) async {
      emit(ProfileVerifiedFailed());
    });

    on<CodeSend>((event, emit) async {
      emit(ProfileOTPSent(verificationID: event.verificationID!));
    });

    on<ProfileLoad>((event, emit) async* {
      yield* _loadSelfReportListToState(event.uid!);
    });

    on<ProfileUpdated>((event, emit) async* {
      yield* _selfReportListToState(event);
    });
  }

  Stream<ProfileState> _loadSelfReportListToState(String otherUID) async* {
    yield ProfileLoading();
    await _subscription.cancel();

    _subscription = profileRepository.getProfile(otherUID).listen((event) {
      add(ProfileUpdated(event));
    });
  }

  Stream<ProfileState> _selfReportListToState(ProfileUpdated event) async* {
    yield ProfileLoaded(profile: event.profile);
  }
}
