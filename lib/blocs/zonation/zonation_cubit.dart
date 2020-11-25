import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';

part 'zonation_state.dart';

class ZonationCubit extends Cubit<ZonationState> {
  ZonationCubit() : super(ZonationInitial());
  
  void loadZonation(Position position) async {
    emit(ZonationLoading());
    try {
      CheckDistributionModel record =
      await CheckDistributionRepository().fetchRecord(
          position.latitude, position.longitude);
      emit(ZonationLoaded(record: record));
    } catch (e) {
      emit(ZonationFailure(e.toString()));
    }
  }
}
