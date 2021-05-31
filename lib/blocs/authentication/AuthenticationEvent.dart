import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => <Object>[];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {

  final bool isApple;

  const LoggedIn({this.isApple = false});

  @override
  List<Object> get props => <Object>[isApple];
}

class LoggedOut extends AuthenticationEvent {}
