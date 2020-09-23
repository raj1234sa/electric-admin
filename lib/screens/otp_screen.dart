import 'package:electric_admin/services/auth_service.dart';
import 'package:electric_admin/services/network_service.dart';
import 'package:electric_admin/utils/constants.dart';
import 'package:electric_admin/utils/dialogues.dart';
import 'package:electric_admin/utils/validation.dart';
import 'package:electric_admin/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPScreen extends StatefulWidget {
  static const ROUTE_NAME = 'OTPScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<OTPScreen> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _otpFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  String _verificationId;
  bool _codeSent = false;
  bool _loading = false;
  String _phoneNumber;
  String _phoneNumberWithCode;

  @override
  void dispose() {
    _phoneController.clear();
    _otpController.clear();
    _phoneFocusNode.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GetBuilder(
      tag: 'auth',
      init: AuthService(),
      builder: (controller) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: _loading
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: _codeSent
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/logo.png',
                                      width: width * 0.3,
                                      height: width * 0.3,
                                    ),
                                    SizedBox(height: 70.0),
                                    Text(
                                      'Verify OTP',
                                      textAlign: TextAlign.center,
                                      style: kTitleTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      'Enter OTP to verify your phone number',
                                      textAlign: TextAlign.center,
                                      style: kSubTitleTextStyle,
                                    ),
                                    Text(
                                      'OTP is sent to $_phoneNumberWithCode',
                                      textAlign: TextAlign.center,
                                      style: kSubTitleTextStyle,
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    _buildOtpField(context),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    buildPrimaryButton(
                                      title: 'VERIFY OTP',
                                      onPress: () async {
                                        await _signIn();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/logo.png',
                                      width: width * 0.3,
                                      height: width * 0.3,
                                    ),
                                    SizedBox(height: 70.0),
                                    Text(
                                      'Sign Up',
                                      textAlign: TextAlign.center,
                                      style: kTitleTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      'Create an account',
                                      textAlign: TextAlign.center,
                                      style: kSubTitleTextStyle,
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    _buildPhoneField(context),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    buildPrimaryButton(
                                      title: 'SEND OTP',
                                      onPress: () {
                                        _submit();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return TextFormField(
      controller: _phoneController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter phone number',
        hintStyle: TextStyle(
          fontSize: 14.0,
        ),
        prefixIcon: Icon(
          Icons.phone,
          color: kDarkBlueColor,
          size: 20.0,
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: kTextFieldColor,
      ),
      textInputAction: TextInputAction.next,
      validator: (phone) {
        return validatePhone(phone);
      },
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return TextFormField(
      controller: _otpController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter OTP',
        hintStyle: TextStyle(
          fontSize: 14.0,
        ),
        prefixIcon: Icon(
          Icons.phone,
          color: kDarkBlueColor,
          size: 20.0,
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: kTextFieldColor,
      ),
      textInputAction: TextInputAction.next,
      validator: (phone) {
        return validatePhone(phone);
      },
    );
  }

  void _submit() async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState.validate()) {
      if (await NetworkService.checkDataConnectivity()) {
        FocusScope.of(context).unfocus();

        _phoneNumber = _phoneController.text;
        _phoneNumberWithCode = '+91' + _phoneController.text;
        setState(() {});
        await _auth.verifyPhoneNumber(
          phoneNumber: '+91' + _phoneController.text,
          timeout: const Duration(seconds: 10),
          verificationCompleted:
              (auth.AuthCredential phoneAuthCredential) async {
            await _signIn(authCredentials: phoneAuthCredential);
          },
          verificationFailed: (error) async {
            await showSimpleDialogue(
              context: context,
              message: 'Verification failed!! Please try again',
              showTwoActions: false,
            );
          },
          codeSent: (verificationId, forceResendingToken) {
            this._verificationId = verificationId;
            setState(() {
              _codeSent = true;
            });
            Get.snackbar('Sent',
                'OTP is sent to ${_phoneController.text} successfully.');
          },
          codeAutoRetrievalTimeout: (verificationId) {
            verificationId = verificationId;
          },
        );
      } else {
        await showSimpleDialogue(
          context: context,
          message: 'Please check your internet connection...',
          showTwoActions: false,
        );
      }
    }
    setState(() {
      _loading = false;
    });
  }

  Future<dynamic> _signIn({auth.AuthCredential authCredentials}) async {
    setState(() {
      _loading = true;
    });
    try {
      final auth.AuthCredential authCred = authCredentials ??
          auth.PhoneAuthProvider.credential(
            verificationId: this._verificationId,
            smsCode: _otpController.text,
          );
      final auth.User firebaseUser =
          (await _auth.signInWithCredential(authCred)).user;
      return firebaseUser;
    } catch (e) {
      print(e.code);
      if (e.code == 'invalid-verification-code') {
        Get.defaultDialog(
          title: 'Invalid',
          content: Text('You have entered invalid OTP'),
        );
      }
    }

    setState(() {
      _loading = false;
    });
  }
}
