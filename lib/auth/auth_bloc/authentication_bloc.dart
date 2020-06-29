import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oilnote/utility/auth_manager.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthManager authManager;

  AuthenticationBloc({@required this.authManager});

  @override
  // TODO: implement initialState
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {

    if (event is AuthenticationStarted) {
      final bool isAuthenticated = await authManager.checkAuthenticate();
      yield isAuthenticated
          ? AuthenticationAuthenticated()
          : AuthenticationUnauthenticated();

    } else if (event is AuthenticationLoggedIn) {
      yield AuthenticationLoading();

    } else if (event is AuthenticationLoggedOut) {
      if ( await authManager.signOut()) {
        yield AuthenticationUnauthenticated();
      }
      yield AuthenticationAuthenticated();

    }
  }
}
