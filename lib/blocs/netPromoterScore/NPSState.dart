part of 'NPSCubit.dart';

abstract class NPSState extends Equatable {
  const NPSState();

  @override
  List<Object> get props => <Object>[];
}

class NPSInitial extends NPSState {}

class NPSLoading extends NPSState {}

class NPSSaved extends NPSState {}

class NPSFailed extends NPSState {
  final String error;

  const NPSFailed(this.error);

  @override
  List<Object> get props => <Object>[error];
}
