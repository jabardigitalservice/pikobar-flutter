part of 'ContactHistorySaveBloc.dart';

abstract class ContactHistorySaveEvent extends Equatable {
  const ContactHistorySaveEvent([List props = const <dynamic>[]]);
}

class ContactHistorySave extends ContactHistorySaveEvent {
  final ContactHistoryModel data;

  ContactHistorySave({@required this.data}):assert(data != null);

  @override
  List<Object> get props => [data];
}

