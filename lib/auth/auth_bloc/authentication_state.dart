import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}