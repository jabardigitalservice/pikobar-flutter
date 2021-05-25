import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

part 'CheckDistributionEvent.dart';

part 'CheckDistributionState.dart';

class CheckDistributionBloc
    extends Bloc<CheckDistributionEvent, CheckDistributionState> {
  final CheckDistributionRepository _checkDistributionRepository;

  CheckDistributionBloc(
      {@required CheckDistributionRepository checkDistributionRepository})
      : assert(checkDistributionRepository != null,
            'checkDistributionRepository must not be null'),
        _checkDistributionRepository = checkDistributionRepository,
        super(CheckDistributionInitial());

  @override
  Stream<CheckDistributionState> mapEventToState(
    CheckDistributionEvent event,
  ) async* {
    if (event is LoadCheckDistribution) {
      if (event.isOther) {
        yield CheckDistributionLoadingIsOther();
      } else {
        yield CheckDistributionLoading();
      }
      try {
        CheckDistributionModel record =
            await _checkDistributionRepository.fetchRecord(
                lat: event.lat,
                long: event.long,
                isOther: event.isOther,
                cityId: event.cityId,
                subCityId: event.cityId);
        yield CheckDistributionLoaded(record: record);
      } on Exception catch (e) {
        yield CheckDistributionFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
