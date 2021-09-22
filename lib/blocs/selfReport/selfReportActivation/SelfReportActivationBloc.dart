import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      final time = DateTime.now().difference(event.date).inDays;
      if (event.type == SelfReportActivateType.PCR && time <= 10) {
        yield SelfReportActivationSuccess();
      } else if (event.type == SelfReportActivateType.ANTIGEN && time <= 3) {
        yield SelfReportActivationSuccess();
      } else
        yield SelfReportActivationFail();
    }
  }
}
