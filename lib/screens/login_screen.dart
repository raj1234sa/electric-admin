import 'package:electric_admin/models/user.dart';
import 'package:electric_admin/screens/otp_screen.dart';
import 'package:electric_admin/services/auth_service.dart';
import 'package:electric_admin/services/network_service.dart';
import 'package:electric_admin/utils/constants.dart';
import 'package:electric_admin/utils/dialogues.dart';
import 'package:electric_admin/utils/validation.dart';
import 'package:electric_admin/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  static const ROUTE_NAME = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user = User(
    emailId: 'test@gmail.com',
    username: 'abhishek',
  );

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _securePassword = true;

  @override
  void dispose() {
    _passwordController.clear();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void submit() async {
    if (_formKey.currentState.validate()) {
      if (await NetworkService.checkDataConnectivity()) {
        FocusScope.of(context).unfocus();
        var result = await AuthService.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        if (result is bool && result) {
        } else if (result is String) {
          showErrorDialog(
            context: context,
            message: result.toString(),
          );
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
                      const _LogoImage(),
                      const SizedBox(height: 70.0),
                      const Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: kTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        'Please enter your credentials',
                        textAlign: TextAlign.center,
                        style: kSubTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      buildNameTextField(),
                      const SizedBox(
                        height: 10,
                      ),
                      buildPasswordTextField(),
                      buildForgetPwText(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      buildPrimaryButton(
                        title: 'LOGIN',
                        onPress: () => submit(),
                      ),
                      const SizedBox(
                        height: 70.0,
                      ),
                      buildLowerText(),
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

  TextFormField buildNameTextField() {
    return TextFormField(
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
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        }
      },
    );
  }

  TextFormField buildPasswordTextField() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      obscureText: _securePassword,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: 'Enter password',
        errorMaxLines: 2,
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
            _securePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
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
      onEditingComplete: () => {},
    );
  }

  Widget buildForgetPwText() {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(ForgotPasswordScreen.ROUTE_NAME);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
        child: Text(
          'Forgot Password ?',
          textAlign: TextAlign.end,
          style: TextStyle(
            color: kDarkBlueColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildLowerText() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(OTPScreen.ROUTE_NAME);
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Don't have an Account ? ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'Sign Up',
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
    );
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Image.asset(
      'assets/images/logo.png',
      width: width * 0.5,
      height: width * 0.5,
    );
  }
}
