import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_permission_event.dart';
part 'location_permission_state.dart';

class LocationPermissionBloc extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  LocationPermissionBloc() : super(LocationPermissionInitial());

  @override
  Stream<LocationPermissionState> mapEventToState(
    LocationPermissionEvent event,
  ) async* {
    if (event is LocationPermissionLoad) {
      yield LocationPermissionLoading();
      yield LocationPermissionLoaded(event.isGranted);
    }
  }
}
