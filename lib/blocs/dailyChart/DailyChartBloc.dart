import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/models/DailyChartModel.dart';
import 'package:pikobar_flutter/repositories/DailyChartRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

part 'DailyChartEvent.dart';

part 'DailyChartState.dart';

class DailyChartBloc extends Bloc<DailyChartEvent, DailyChartState> {
  final DailyChartRepository _dailyChartRepository;

  DailyChartBloc({required DailyChartRepository dailyChartRepository})
      : _dailyChartRepository = dailyChartRepository,
        super(DailyChartInitial());

  @override
  Stream<DailyChartState> mapEventToState(
    DailyChartEvent event,
  ) async* {
    if (event is LoadDailyChart) {
      yield DailyChartLoading();
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        DailyChartModel record =
            await _dailyChartRepository.fetchRecord(position);
        if (record.data.isNotEmpty) {
          yield DailyChartLoaded(record: record);
        } else {
          yield DailyChartFailure(
              error: CustomException.onConnectionException(
                  ErrorException.socketException));
        }
      } on Exception catch (e) {
        yield DailyChartFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
