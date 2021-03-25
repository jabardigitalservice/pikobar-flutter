import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

part 'CheckdistributionEvent.dart';
part 'CheckdistributionState.dart';

class CheckDistributionBloc
    extends Bloc<CheckdistributionEvent, CheckdistributionState> {
  final CheckDistributionRepository _checkDistributionRepository;

  CheckDistributionBloc(
      {@required CheckDistributionRepository checkDistributionRepository})
      : assert(checkDistributionRepository != null),
        _checkDistributionRepository = checkDistributionRepository, super(CheckdistributionInitial());

  @override
  Stream<CheckdistributionState> mapEventToState(
    CheckdistributionEvent event,
  ) async* {
    if (event is LoadCheckDistribution) {
      if (event.isOther) {
        yield CheckDistributionLoadingIsOther();
      } else {
        yield CheckDistributionLoading();
      }
      try {
        CheckDistributionModel record =
            await _checkDistributionRepository.fetchRecord(event.lat, event.long);
        yield CheckDistributionLoaded(record: record);
      } catch (e) {
        yield CheckDistributionFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
