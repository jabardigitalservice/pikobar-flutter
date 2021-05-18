import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pikobar_flutter/models/DailyChartModel.dart';
import 'package:pikobar_flutter/repositories/DailyChartRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

part 'DailyChartEvent.dart';

part 'DailyChartState.dart';

class DailyChartBloc extends Bloc<DailyChartEvent, DailyChartState> {
  final DailyChartRepository _dailyChartRepository;

  DailyChartBloc({@required DailyChartRepository dailyChartRepository})
      : assert(DailyChartRepository != null,
            'DailyChartRepository must not be null'),
        _dailyChartRepository = dailyChartRepository,
        super(DailyChartInitial());

  @override
  Stream<DailyChartState> mapEventToState(
    DailyChartEvent event,
  ) async* {
    if (event is LoadDailyChart) {
      yield DailyChartLoading();

      try {
        final String cityId = await _dailyChartRepository.getCityId(
            event.cityId, event.listCityId);
        final DailyChartModel record = await _dailyChartRepository.fetchRecord(
            cityId.replaceAll('.', ''), event.apiKey);
        yield DailyChartLoaded(record: record);
      } on Exception catch (e) {
        yield DailyChartFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
