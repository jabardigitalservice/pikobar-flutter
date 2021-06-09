part of 'ContactHistorySaveBloc.dart';

abstract class ContactHistorySaveState extends Equatable {
  const ContactHistorySaveState();

  @override
  List<Object> get props => <Object>[];
}

class ContactHistorySaveInitial extends ContactHistorySaveState {}

class ContactHistorySaveLoading extends ContactHistorySaveState {}

class ContactHistorySaved extends ContactHistorySaveState {}

class ContactHistorySaveFailure extends ContactHistorySaveState {
  final String error;

  const ContactHistorySaveFailure({this.error});

  @override
  List<Object> get props => <Object>[error];
}
