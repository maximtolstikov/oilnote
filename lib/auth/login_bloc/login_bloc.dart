import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oilnote/auth/auth_bloc/authentication_bloc.dart';
import 'package:oilnote/auth/auth_bloc/authentication_event.dart';
import 'package:oilnote/auth/login_bloc/login_event.dart';
import 'package:oilnote/utility/auth_manager.dart';

import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthManager authManager;
  final AuthenticationBloc authBloc;

  LoginBloc({@required this.authManager, @required this.authBloc})
      : assert(authManager != null),
        assert(authBloc != null);

  @override
  // TODO: implement initialState
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginPhoneSent) {
      authManager.verification(event.phoneNumber, this);
      yield LoginProcessing();
    } else if (event is LoginCodeSent) {
      authManager.treatSMS(event.code, this);
      yield LoginProcessing();
    } else if (event is LoginErrorReturned) {
      yield LoginFailure(error: event.error.toString());
    } else if (event is LoginPhoneVerified) {
      yield LoginPhoneCorrect();
    } else if (event is LoginCodeVerified) {
      authBloc.add(AuthenticationLoggedIn());
      yield LoginSuccess();
    }
  }
}
