part of 'ContactHistoryListBloc.dart';

abstract class ContactHistoryListState extends Equatable {
  const ContactHistoryListState();

  @override
  List<Object> get props => <Object>[];
}

class ContactHistoryListInitial extends ContactHistoryListState {}

class ContactHistoryListLoading extends ContactHistoryListState {}

class ContactHistoryListLoaded extends ContactHistoryListState {
  final QuerySnapshot querySnapshot;

  const ContactHistoryListLoaded({@required this.querySnapshot});

  @override
  List<Object> get props => <Object>[querySnapshot];
}

class ContactHistoryListFailure extends ContactHistoryListState {
  final String error;

  const ContactHistoryListFailure({@required this.error});

  @override
  List<Object> get props => <Object>[error];
}
