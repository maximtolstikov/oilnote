import 'package:equatable/equatable.dart';

class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {}

class AuthenticationLoggedOut extends AuthenticationEvent {}
