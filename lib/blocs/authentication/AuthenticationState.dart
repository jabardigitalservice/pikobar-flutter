import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/UserModel.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const <dynamic>[]]);
}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';

  @override
  List<Object> get props => [];
}

class AuthenticationAuthenticated extends AuthenticationState {
  final   UserModel record;
  AuthenticationAuthenticated({this.record});
  @override
  String toString() => 'AuthenticationAuthenticated';

  @override
  List<Object> get props => [record];
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';

  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';

  @override
  List<Object> get props => [];
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'Authentication { error: $error }';

  @override
  List<Object> get props => [error];
}
