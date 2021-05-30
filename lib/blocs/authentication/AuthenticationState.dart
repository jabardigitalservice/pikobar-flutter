import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/UserModel.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';

  @override
  List<Object> get props => <Object>[];
}

class AuthenticationAuthenticated extends AuthenticationState {
  final UserModel record;

  const AuthenticationAuthenticated({this.record});

  @override
  String toString() => 'AuthenticationAuthenticated';

  @override
  List<Object> get props => <Object>[record];
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';

  @override
  List<Object> get props => <Object>[];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';

  @override
  List<Object> get props => <Object>[];
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  const AuthenticationFailure({@required this.error});

  @override
  String toString() => 'Authentication { error: $error }';

  @override
  List<Object> get props => <Object>[error];
}
