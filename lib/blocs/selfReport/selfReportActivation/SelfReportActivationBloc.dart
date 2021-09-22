import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'SelfReportActivationEvent.dart';
part 'SelfReportActivationState.dart';

class SelfReportActivationBloc
    extends Bloc<SelfReportActivationEvent, SelfReportActivationState> {
  SelfReportActivationBloc() : super(SelfreportactivationblocInitial());

  @override
  Stream<SelfReportActivationState> mapEventToState(
      SelfReportActivationEvent event) {}
}
