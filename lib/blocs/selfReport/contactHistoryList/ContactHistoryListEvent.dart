part of 'ContactHistoryListBloc.dart';

abstract class ContactHistoryListEvent extends Equatable {
  const ContactHistoryListEvent();

  @override
  List<Object> get props => <Object>[];
}

class ContactHistoryListLoad extends ContactHistoryListEvent {}

class ContactHistoryListUpdated extends ContactHistoryListEvent {
  final QuerySnapshot contactHistoryList;

  const ContactHistoryListUpdated(this.contactHistoryList);

  @override
  List<Object> get props => <Object>[contactHistoryList];
}



