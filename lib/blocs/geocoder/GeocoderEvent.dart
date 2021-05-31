import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeocoderEvent extends Equatable {
  const GeocoderEvent();
}

class GeocoderGetLocation extends GeocoderEvent {
  final LatLng coordinate;

  const GeocoderGetLocation({@required this.coordinate})
      : assert(coordinate != null, 'coordinate must not be null');

  @override
  List<Object> get props => <Object>[coordinate];
}
