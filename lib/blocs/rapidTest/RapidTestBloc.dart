import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/blocs/rapidTest/Bloc.dart';
import 'package:pikobar_flutter/models/RapidTestModel.dart';
import 'package:pikobar_flutter/repositories/RapidTestRepository.dart';
import 'package:pikobar_flutter/utilities/exceptions/CustomException.dart';

class RapidTestBloc extends Bloc<RapidTestEvent, RapidTestState> {
  final RapidTestReposity _rapidTestReposity;

  RapidTestBloc({@required RapidTestReposity rapidTestReposity})
      : assert(rapidTestReposity != null),
        _rapidTestReposity = rapidTestReposity, super(RapidTestInitial());

  @override
  Stream<RapidTestState> mapEventToState(
    RapidTestEvent event,
  ) async* {
    if (event is RapidTestLoad) {
      yield RapidTestLoading();
      try {
        RapidTestModel record = await _rapidTestReposity.fetchRecord();
        yield RapidTestLoaded(record: record);
      } on Exception catch (e) {
        yield RapidTestFailure(
            error: CustomException.onConnectionException(e.toString()));
      }
    }
  }
}
