import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

part 'zonation_state.dart';

class ZonationCubit extends Cubit<ZonationState> {
  ZonationCubit() : super(ZonationInitial());

  Future<void> loadZonation() async {
    emit(ZonationLoading());
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final CheckDistributionModel record = await CheckDistributionRepository()
          .fetchRecord(lat: position.latitude, long: position.longitude);
      emit(ZonationLoaded(record: record, position: position));
    } on Exception catch (e) {
      emit(
          ZonationFailure(CustomException.onConnectionException(e.toString())));
    }
  }
}
