part of 'ContactHistorySaveBloc.dart';

abstract class ContactHistorySaveState extends Equatable {
  const ContactHistorySaveState([List props = const <dynamic>[]]);
}

class ContactHistorySaveInitial extends ContactHistorySaveState {
  @override
  List<Object> get props => [];
}

class ContactHistorySaveLoading extends ContactHistorySaveState {
  @override
  List<Object> get props => [];
}

class ContactHistorySaved extends ContactHistorySaveState {
  @override
  List<Object> get props => [];
}

class ContactHistorySaveFailure extends ContactHistorySaveState {
  final String error;

  ContactHistorySaveFailure({this.error});

  @override
  List<Object> get props => [error];
}
