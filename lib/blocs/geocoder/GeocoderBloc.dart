import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';
import './Bloc.dart';

class GeocoderBloc extends Bloc<GeocoderEvent, GeocoderState> {
  final GeocoderRepository geocoderRepository;

  GeocoderBloc({required this.geocoderRepository})
      : assert(
            geocoderRepository != null, 'geocoderRepository must not be null'),
        super(GeocoderStateInitial());

  @override
  Stream<GeocoderState> mapEventToState(
    GeocoderEvent event,
  ) async* {
    if (event is GeocoderGetLocation) {
      yield GeocoderLoading();

      try {
        String address = await geocoderRepository.getAddress(event.coordinate);

        yield GeocoderLoaded(address: address);
      } on Exception catch (e) {
        yield GeocoderFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
