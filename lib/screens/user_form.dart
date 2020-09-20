import 'package:electric_admin/services/auth_service_my.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class UserFormScreen extends StatefulWidget {
  static const ROUTE_NAME = 'UserFormScreen';
  auth.User firebaseUser;
  String phoneNumber;
  UserFormScreen({@required this.firebaseUser, @required this.phoneNumber});
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                initialValue: widget.phoneNumber,
                enabled: false,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
                controller: _emailController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
              ),
              RaisedButton(
                onPressed: () async {
                  await AuthService.linkWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  // await AuthService.signIn(authCredential);
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
