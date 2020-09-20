import 'package:electric_admin/screens/signup_screen.dart';
import 'package:electric_admin/screens/user_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static String phoneNumber;
  static String verificationId;
  static User firebaseUser;

  static Future<void> sendOtpToPhone(String number) async {
    phoneNumber = number;
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
      (AuthCredential credential) async {
    firebaseUser = await signIn(credential);
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
        print(snapshot);
        if (snapshot.hasData) {
          return UserFormScreen(
            firebaseUser: snapshot.data,
            phoneNumber: phoneNumber,
          );
        } else {
          return SignUpScreen();
        }
      },
    );
  }

  static Future<User> signIn(AuthCredential authCredential) async {
    await _auth.signInWithCredential(authCredential);
    return _auth.currentUser;
  }

  static void signOut() async {
    await _auth.signOut();
  }

  static Future<void> linkWithEmailAndPassword(
      {String email, String password}) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    firebaseUser =
        (await _auth.currentUser.linkWithCredential(credential)).user;
  }
}
