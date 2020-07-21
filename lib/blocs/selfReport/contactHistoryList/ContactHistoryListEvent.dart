part of 'ContactHistoryListBloc.dart';

abstract class ContactHistoryListEvent extends Equatable {
  const ContactHistoryListEvent([List props = const <dynamic>[]]);
}

class ContactHistoryListLoad extends ContactHistoryListEvent {
  @override
  List<Object> get props => [];
}

class ContactHistoryListUpdated extends ContactHistoryListEvent {
  final QuerySnapshot contactHistoryList;

  const ContactHistoryListUpdated(this.contactHistoryList);

  @override
  List<Object> get props => [contactHistoryList];
}



