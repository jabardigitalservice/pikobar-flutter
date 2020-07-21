part of 'ContactHistoryDetailBloc.dart';

abstract class ContactHistoryDetailState extends Equatable {
  const ContactHistoryDetailState([List props = const <dynamic>[]]);
}

class ContactHistoryDetailInitial extends ContactHistoryDetailState {
  @override
  List<Object> get props => [];
}

class ContactHistoryDetailLoading extends ContactHistoryDetailState {
  @override
  List<Object> get props => [];
}

class ContactHistoryDetailLoaded extends ContactHistoryDetailState {
  final DocumentSnapshot documentSnapshot;

  ContactHistoryDetailLoaded({@required this.documentSnapshot});

  @override
  List<Object> get props => [documentSnapshot];
}

class ContactHistoryDetailFailure extends ContactHistoryDetailState {
  final String error;

  ContactHistoryDetailFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
