part of 'NPSCubit.dart';

abstract class NPSState extends Equatable {
  const NPSState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class NPSInitial extends NPSState {
}

class NPSLoading extends NPSState {
}

class NPSSaved extends NPSState {
}

class NPSFailed extends NPSState {
  final String error;

  const NPSFailed(this.error);

  @override
  List<Object> get props => [error];
}
