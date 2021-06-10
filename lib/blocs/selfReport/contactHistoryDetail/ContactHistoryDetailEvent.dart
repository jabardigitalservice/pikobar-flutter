part of 'ContactHistoryDetailBloc.dart';

abstract class ContactHistoryDetailEvent extends Equatable {
  const ContactHistoryDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class ContactHistoryDetailLoad extends ContactHistoryDetailEvent {
  final String contactHistoryId;

  const ContactHistoryDetailLoad({@required this.contactHistoryId});

  @override
  List<Object> get props => [contactHistoryId];
}
