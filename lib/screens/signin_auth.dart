import 'package:electric_admin/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignInAuthScreen extends StatelessWidget {
  static const ROUTE_NAME = 'signin-auth-screen';
  @override
  Widget build(BuildContext context) {
    return AuthService().handleRegisterAuth();
  }
}
