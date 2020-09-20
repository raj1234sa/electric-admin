import 'package:electric_admin/services/auth_service_my.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const ROUTE_NAME = 'SignUpScreenmy';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhoneNumberField(),
                _buildOTPField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
      ),
      keyboardType: TextInputType.number,
      onFieldSubmitted: (value) async {
        await AuthService.sendOtpToPhone(value);
      },
      // validator: (value) => validatePhoneNumber(value),
    );
  }

  Widget _buildOTPField() {
    return TextFormField(
      controller: _otpController,
      decoration: InputDecoration(
        labelText: 'Enter OTP',
      ),
      keyboardType: TextInputType.number,
    );
  }
}
