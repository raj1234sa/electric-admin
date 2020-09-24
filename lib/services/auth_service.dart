import 'package:electric_admin/models/user.dart';
import 'package:electric_admin/screens/otp_screen.dart';
import 'package:electric_admin/screens/signup_screen.dart';
import 'package:electric_admin/utils/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  static auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  static CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
  String phoneNumber;
  String verificationId;
  auth.User firebaseUser;
  bool codeSent = false;
  User _loggedInUser;
  auth.User _firebaseLoggedInUser;

  Future<void> setLoggedInUser(User user) async {
    _loggedInUser = user;
    await signInWithEmailAndPassword(user.emailId, user.password);
    update();
  }

  User get loggedInUser {
    return _loggedInUser;
  }

  auth.User get firebaseLoggedInUser {
    return _firebaseLoggedInUser;
  }

  handleRegisterAuth() {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SignUpScreen(firebaseUser: snapshot.data);
        } else {
          return OTPScreen();
        }
      },
    );
  }

  static Future<void> linkWithEmailAndPassword(
      {String email, String password}) async {
    auth.AuthCredential credential =
        auth.EmailAuthProvider.credential(email: email, password: password);
    await _auth.currentUser.linkWithCredential(credential);
  }

  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    String errorMessage = "";
    try {
      auth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      _usersRef.doc(userCredential.user.uid).get().then((userdata) async {
        _firebaseLoggedInUser = userCredential.user;
        User user = User.fromMap(userdata.data());
        await SharedPref.saveUserToSharedRef('loggedInUser', user);
        update();
      });
      return true;
    } catch (e) {
      print(e.code);
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      return errorMessage;
    }
  }

  Future<bool> signOut() async {
    await auth.FirebaseAuth.instance.signOut();
    _loggedInUser = null;
    _firebaseLoggedInUser = null;
    return await SharedPref.remove('loggedInUser');
  }
}
