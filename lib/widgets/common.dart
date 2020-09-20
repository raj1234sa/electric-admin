import 'package:electric_admin/screens/login_screen.dart';
import 'package:electric_admin/services/auth_service.dart';
import 'package:flutter/material.dart';

Widget buildLogoutButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.exit_to_app),
    onPressed: () async {
      await AuthService.signOut();
      Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
    },
  );
}
