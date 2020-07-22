part of 'ContactHistoryListBloc.dart';


abstract class ContactHistoryListState extends Equatable {
  const ContactHistoryListState([List props = const <dynamic>[]]);
}

class ContactHistoryListInitial extends ContactHistoryListState {
  @override
  List<Object> get props => [];
}

class ContactHistoryListLoading extends ContactHistoryListState {
  @override
  List<Object> get props => [];
}



class ContactHistoryListLoaded extends ContactHistoryListState {
  final QuerySnapshot querySnapshot;


  ContactHistoryListLoaded({@required this.querySnapshot});

  @override
  List<Object> get props => [querySnapshot];
}


class ContactHistoryListFailure extends ContactHistoryListState {
  final String error;

  ContactHistoryListFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
