part of 'location_permission_bloc.dart';

abstract class LocationPermissionEvent extends Equatable {
  const LocationPermissionEvent();

  @override
  List<Object> get props => [];
}

class LocationPermissionLoad extends LocationPermissionEvent {
  final bool isGranted;

  const LocationPermissionLoad(this.isGranted);
}