import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';

part 'SelfReportActivationEvent.dart';
part 'SelfReportActivationState.dart';

class SelfReportActivationBloc
    extends Bloc<SelfReportActivationEvent, SelfReportActivationState> {
  SelfReportActivationBloc() : super(SelfReportActivationInitial());

  @override
  Stream<SelfReportActivationState> mapEventToState(
      SelfReportActivationEvent event) async* {
    if (event is SelfReportActivate) {
      yield SelfReportActivationLoading();
      await Future.delayed(Duration(seconds: 2));
      String userId = await AuthRepository().getToken();
      final time = DateTime.now().difference(event.date).inDays;
      if ((event.type == SelfReportActivateType.PCR && time <= 10) ||
          (event.type == SelfReportActivateType.ANTIGEN && time <= 3)) {
        await SelfReportRepository().activateSelfReport(
          userId: userId,
          date: event.date,
        );
        yield SelfReportActivationSuccess();
      } else
        yield SelfReportActivationFail();
    }
  }
}
