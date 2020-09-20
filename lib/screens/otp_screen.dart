import 'package:electric_admin/screens/login_screen.dart';
import 'package:electric_admin/services/auth_service.dart';
import 'package:electric_admin/services/network_service.dart';
import 'package:electric_admin/utils/constants.dart';
import 'package:electric_admin/utils/dialogues.dart';
import 'package:electric_admin/utils/validation.dart';
import 'package:electric_admin/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

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

  @override
  void dispose() {
    _phoneController.clear();
    _otpController.clear();
    _phoneFocusNode.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      if (await NetworkService.checkDataConnectivity()) {
        FocusScope.of(context).unfocus();
        String result = await AuthService.sendOtpVerification(
          _phoneController.text,
        );
        Toast.show(result, context, duration: Toast.LENGTH_LONG + 4);
        if (result == kAccountSuccessMessage) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.ROUTE_NAME);
        }
      } else {
        await showSimpleDialogue(
          context: context,
          message: 'Please check your internet connection...',
          showTwoActions: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: width * 0.5,
                        height: width * 0.5,
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
                      TextFormField(
                        focusNode: _phoneFocusNode,
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildPrimaryButton(
                        title: 'SEND OTP',
                        onPress: () {
                          _submit();
                        },
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.ROUTE_NAME);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Already have an Account ? ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: kDarkBlueColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
