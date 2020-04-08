import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeocoderEvent extends Equatable {
  GeocoderEvent([List props = const <dynamic>[]]);
}

class GeocoderGetLocation extends GeocoderEvent {
  final LatLng coordinate;

  GeocoderGetLocation({@required this.coordinate}) : assert(coordinate != null);

  @override
  String toString() {
    return 'Event getLocation';
  }

  @override
  List<Object> get props => [coordinate];
}
