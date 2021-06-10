part of 'ContactHistorySaveBloc.dart';

abstract class ContactHistorySaveEvent extends Equatable {
  const ContactHistorySaveEvent();

  @override
  List<Object> get props => <Object>[];
}

class ContactHistorySave extends ContactHistorySaveEvent {
  final ContactHistoryModel data;

  ContactHistorySave({@required this.data})
      : assert(data != null, 'data must not be null');

  @override
  List<Object> get props => <Object>[data];
}
