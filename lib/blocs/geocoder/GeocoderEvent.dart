import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeocoderEvent extends Equatable {
  GeocoderEvent([List props = const <dynamic>[]]);
}

class GeocoderGetLocation extends GeocoderEvent {
  final LatLng coordinate;

  GeocoderGetLocation({@required this.coordinate}) : assert(coordinate != null, 'coordinate must not be null');

  @override
  String toString() => 'Event getLocation';

  @override
  List<Object> get props => [coordinate];
}
