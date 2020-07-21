part of 'ContactHistoryDetailBloc.dart';

abstract class ContactHistoryDetailEvent extends Equatable {
  const ContactHistoryDetailEvent([List props = const <dynamic>[]]);
}

class ContactHistoryDetailLoad extends ContactHistoryDetailEvent {
  final String contactHistoryId;

  ContactHistoryDetailLoad({@required this.contactHistoryId});

  @override
  List<Object> get props => [];
}
