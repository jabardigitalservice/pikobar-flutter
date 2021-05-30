import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => <Object>[];
}

class LoggedIn extends AuthenticationEvent {

  final bool isApple;

  const LoggedIn({this.isApple = false});

  @override
  String toString() => 'LoggedIn';

  @override
  List<Object> get props => <Object>[];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => <Object>[];
}
