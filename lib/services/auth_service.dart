import 'package:electric_admin/screens/service_list.dart';
import 'package:electric_admin/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static String _phoneNumber;
  static String verificationId;

  static Future<void> sendOtpToPhone(String number) async {
    _phoneNumber = number;
    _auth.verifyPhoneNumber(
      phoneNumber: '+91' + number,
      timeout: const Duration(seconds: 10),
      verificationCompleted: _verified,
      verificationFailed: _verificationFailed,
      codeSent: _smsSent,
      codeAutoRetrievalTimeout: _autoRetrievalTimeout,
    );
  }

  static final PhoneVerificationCompleted _verified =
      (AuthCredential credential) {
    signIn(credential);
  };

  static final PhoneVerificationFailed _verificationFailed =
      (FirebaseAuthException exception) {
    print("${exception.message}");
  };

  static final PhoneCodeSent _smsSent = (String verId, [int forceResend]) {
    verificationId = verId;
  };

  static final PhoneCodeAutoRetrievalTimeout _autoRetrievalTimeout =
      (String verId) {
    verificationId = verId;
  };

  static Widget handleAuth() {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ServicesListScreen();
        } else {
          return SignUpScreen();
        }
      },
    );
  }

  static void signIn(AuthCredential authCredential) async {
    _auth.signInWithCredential(authCredential);
  }

  void signOut() async {
    await _auth.signOut();
  }
}
