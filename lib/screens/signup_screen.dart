import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_admin/models/user.dart';
import 'package:electric_admin/screens/login_screen.dart';
import 'package:electric_admin/services/auth_service.dart';
import 'package:electric_admin/services/network_service.dart';
import 'package:electric_admin/utils/constants.dart';
import 'package:electric_admin/utils/dialogues.dart';
import 'package:electric_admin/utils/validation.dart';
import 'package:electric_admin/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class SignUpScreen extends StatefulWidget {
  static const ROUTE_NAME = 'sign-up';
  final auth.User firebaseUser;
  final String phoneNumber;
  SignUpScreen({@required this.firebaseUser, this.phoneNumber});
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
  final _formKey = GlobalKey<FormState>();
  bool _securePassword = true;
  bool _secureRePassword = true;
  bool _loading = false;

  @override
  void initState() {
    _phoneController.text = widget.firebaseUser.phoneNumber;
    super.initState();
  }

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
            child: _loading
                ? CircularProgressIndicator()
                : SingleChildScrollView(
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
                            _buildUsernameField(context),
                            SizedBox(
                              height: 10,
                            ),
                            _buildEmailField(context),
                            SizedBox(
                              height: 10,
                            ),
                            _buildPhoneField(context),
                            SizedBox(
                              height: 10,
                            ),
                            _buildPasswordField(context),
                            SizedBox(
                              height: 10,
                            ),
                            _buildRePasswordField(context),
                            SizedBox(
                              height: 20.0,
                            ),
                            buildPrimaryButton(
                              title: 'REGISTER',
                              onPress: () {
                                _submit(context);
                              },
                            ),
                            SizedBox(
                              height: 70.0,
                            ),
                            Center(
                              child: buildBottomText(context),
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

  GestureDetector buildBottomText(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).pushReplacementNamed(LoginScreen.ROUTE_NAME);
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
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return TextFormField(
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
          FocusScope.of(context).requestFocus(_emailIdFocusNode);
        }
      },
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
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
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        }
      },
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return TextFormField(
      enabled: false,
      controller: _phoneController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
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
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
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
      onFieldSubmitted: (value) {
        if (value.isNotEmpty) {
          FocusScope.of(context).requestFocus(_rePasswordFocusNode);
        }
      },
      onEditingComplete: () => {},
    );
  }

  Widget _buildRePasswordField(BuildContext context) {
    return TextFormField(
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
        return validateRePassword(
            _passwordController.text, _rePasswordController.text);
      },
      onEditingComplete: () => {},
    );
  }

  void _submit(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState.validate()) {
      if (await NetworkService.checkDataConnectivity()) {
        FocusScope.of(context).unfocus();
        try {
          await AuthService.linkWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser;
          await firebaseUser.updateProfile(
              displayName: _userNameController.text);
          User user = User(
            emailId: firebaseUser.email,
            phoneNumber: firebaseUser.phoneNumber,
            userId: firebaseUser.uid,
            username: _userNameController.text,
            password: _passwordController.text,
          );
          final CollectionReference _usersRef =
              FirebaseFirestore.instance.collection('users');
          _usersRef.doc(firebaseUser.uid).set(user.toMap());
          Toast.show("Account is created successfully", context,
              duration: Toast.LENGTH_LONG + 4);
          Get.toNamed(LoginScreen.ROUTE_NAME);
        } catch (e) {
          await showSimpleDialogue(
            context: context,
            message: "${e.code} - ${e.message}",
            showTwoActions: false,
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
    setState(() {
      _loading = false;
    });
  }
}
