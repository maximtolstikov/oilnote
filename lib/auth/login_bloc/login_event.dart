import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginPhoneSent extends LoginEvent {
  final String phoneNumber;

  const LoginPhoneSent({@required this.phoneNumber});

  @override
  // TODO: implement props
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'LoginPhoneSend {phone number: $phoneNumber}';
}

class LoginCodeSent extends LoginEvent {
  final String code;

  const LoginCodeSent({@required this.code});

  @override
  // TODO: implement props
  List<Object> get props => [code];

  @override
  String toString() => 'LoginCodeSend {code: $code}';
}

class LoginErrorReturned extends LoginEvent {
  final AssertionError error;

  const LoginErrorReturned(this.error);

  @override
  // TODO: implement props
  List<Object> get props => [error];

  @override
  String toString() => 'LoginResultReturned {error: $error}';
}

class LoginPhoneVerified extends LoginEvent {}

class LoginCodeVerified extends LoginEvent {}
