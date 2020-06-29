import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:oilnote/auth/login_bloc/login_bloc.dart';
import 'package:oilnote/auth/login_bloc/login_event.dart';

class AuthManager {
  final _fa = FirebaseAuth.instance;
  String _verificationId;

  Future<bool> signOut() async {
    await _fa.signOut();
    return await userId() == null ? true : false;
  }

  Future<String> userId() async {
    return _fa.currentUser().then((user) => user.uid);
  }

  Future<bool> checkAuthenticate() async {
    return await _fa.currentUser() != null;
  }

  void verification(String phoneNumber, LoginBloc block) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _fa.signInWithCredential(phoneAuthCredential).then((AuthResult value) {
        if (value.user != null) {
          block.add(LoginPhoneVerified());
        } else {
          block.add(LoginErrorReturned(AssertionError("Error validation")));
        }
      }).catchError((error) {
        block.add(LoginErrorReturned(AssertionError(error.toString())));
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      var message = authException.code == "invalidPhoneNumber"
          ? "Entered phone number is wrong!"
          : "Please check phone number and try again.";
      block.add(LoginErrorReturned(AssertionError(message)));
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      block.add(LoginPhoneVerified());
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      block.add(LoginErrorReturned(AssertionError("Error timeout")));
    };

    // TODO: Change country code

    await _fa.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void treatSMS(String code, LoginBloc block) async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: code);

    await _fa
        .signInWithCredential(_authCredential)
        .then((AuthResult value) async {
      if (value.user != null) {
        block.add(LoginCodeVerified());
      } else {
        block.add(LoginErrorReturned(AssertionError("Error validation!")));
      }
    }).catchError((error) {
      var e = error as PlatformException;
      if (e?.code == "ERROR_INVALID_VERIFICATION_CODE") {
        block.add(
            LoginErrorReturned(AssertionError("Invalid verification code!")));
      } else {
        block.add(LoginErrorReturned(AssertionError("Something went wrong!")));
      }
    });
  }
}