import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';

class GeocoderRepository {
  Future getAddress(LatLng coordinate) async {
    if (coordinate != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          coordinate.latitude, coordinate.longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        final stringAddress = pos.thoroughfare +
            ', ' +
            pos.locality +
            ', ' +
            pos.subAdministrativeArea;

        return stringAddress;
      } else {
        throw Exception(Dictionary.somethingWrong);
      }
    }
  }

  Future getCity(LatLng coordinate) async {
    if (coordinate != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          coordinate.latitude, coordinate.longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];

        return pos.subAdministrativeArea;
      } else {
        throw Exception(Dictionary.somethingWrong);
      }
    }
  }
}
