part of 'location_permission_bloc.dart';

abstract class LocationPermissionState extends Equatable {
  const LocationPermissionState();

  @override
  List<Object> get props => [];
}

class LocationPermissionInitial extends LocationPermissionState {
}

class LocationPermissionLoading extends LocationPermissionState {
}

class LocationPermissionLoaded extends LocationPermissionState {
  final bool isGranted;

  const LocationPermissionLoaded(this.isGranted);
}