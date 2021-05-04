import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';

part 'zonation_state.dart';

class ZonationCubit extends Cubit<ZonationState> {
  ZonationCubit() : super(ZonationInitial());
  
  void loadZonation() async {
    emit(ZonationLoading());
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      CheckDistributionModel record =
      await CheckDistributionRepository().fetchRecord(
          position.latitude, position.longitude);
      emit(ZonationLoaded(record: record, position: position));
    } on Exception catch (e) {
      emit(ZonationFailure(e.toString()));
    }
  }
}
