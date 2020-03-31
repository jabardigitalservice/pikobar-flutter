import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';

import './Bloc.dart';

class ProfileBloc
    extends Bloc<ProfileEvent, ProfileState> {
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

    if(event is Verify){
       yield ProfileLoading();
      try {
       var getStatus= await profileRepository.sendCodeToPhoneNumber(event.id, event.phoneNumber);
       if (get) {
         
       } else {
       }
        yield ProfileSaved();
      } catch (e) {
        yield ProfileFailure(error: e.toString());
      }
    }

    
  }
}
