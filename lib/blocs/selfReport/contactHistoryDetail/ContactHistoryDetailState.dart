part of 'ContactHistoryDetailBloc.dart';

abstract class ContactHistoryDetailState extends Equatable {
  const ContactHistoryDetailState();

  @override
  List<Object> get props => <Object>[];
}

class ContactHistoryDetailInitial extends ContactHistoryDetailState {}

class ContactHistoryDetailLoading extends ContactHistoryDetailState {}

class ContactHistoryDetailLoaded extends ContactHistoryDetailState {
  final DocumentSnapshot documentSnapshot;

  const ContactHistoryDetailLoaded({@required this.documentSnapshot});

  @override
  List<Object> get props => <Object>[documentSnapshot];
}

class ContactHistoryDetailFailure extends ContactHistoryDetailState {
  final String error;

  const ContactHistoryDetailFailure({@required this.error});

  @override
  List<Object> get props => <Object>[error];
}
