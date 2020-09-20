import 'package:electric_admin/screens/login_screen.dart';
import 'package:electric_admin/services/auth_service.dart';
import 'package:electric_admin/services/network_service.dart';
import 'package:electric_admin/utils/constants.dart';
import 'package:electric_admin/utils/dialogues.dart';
import 'package:electric_admin/utils/validation.dart';
import 'package:electric_admin/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class SignUpScreen extends StatefulWidget {
  static const ROUTE_NAME = 'sign-up';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  FocusNode _emailIdFocusNode = FocusNode();
  FocusNode _rePasswordFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _securePassword = true;
  bool _secureRePassword = true;

  @override
  void dispose() {
    _userNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _rePasswordController.clear();

    _emailIdFocusNode.dispose();
    _passwordFocusNode.dispose();
    _rePasswordFocusNode.dispose();

    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      if (await NetworkService.checkDataConnectivity()) {
        FocusScope.of(context).unfocus();
        String result = await AuthService.signUpWithEmailAndPassword(
          _emailController.text,
          _userNameController.text,
          _passwordController.text,
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
    var height = MediaQuery.of(context).size.height;
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
                        controller: _userNameController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Enter username',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: kDarkBlueColor,
                            size: 20.0,
                          ),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kTextFieldColor,
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (username) {
                          return validateUserName(username);
                        },
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context)
                                .requestFocus(_emailIdFocusNode);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _emailIdFocusNode,
                        controller: _emailController,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter email',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: kDarkBlueColor,
                            size: 20.0,
                          ),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kTextFieldColor,
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (email) {
                          return validateEmail(email);
                        },
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context)
                                .requestFocus(_phoneFocusNode);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
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
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        obscureText: _securePassword,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_open,
                            color: kDarkBlueColor,
                            size: 20.0,
                          ),
                          suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            icon: FaIcon(
                              _securePassword
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 16,
                              color: kDarkBlueColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _securePassword = !_securePassword;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kTextFieldColor,
                        ),
                        validator: (password) {
                          return validatePassword(password);
                        },
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context)
                                .requestFocus(_rePasswordFocusNode);
                          }
                        },
                        onEditingComplete: () => {},
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _rePasswordFocusNode,
                        controller: _rePasswordController,
                        obscureText: _secureRePassword,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Re-enter password',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_open,
                            color: kDarkBlueColor,
                            size: 20.0,
                          ),
                          suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            icon: FaIcon(
                              _secureRePassword
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 16,
                              color: kDarkBlueColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _secureRePassword = !_secureRePassword;
                              });
                            },
                          ),
                          errorMaxLines: 2,
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kTextFieldColor,
                        ),
                        validator: (rePassword) {
                          return validateRePassword(_passwordController.text,
                              _rePasswordController.text);
                        },
                        onEditingComplete: () => {},
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      buildPrimaryButton(
                        title: 'REGISTER',
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
