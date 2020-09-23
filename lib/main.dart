import 'package:electric_admin/providers/service_provider.dart';
import 'package:electric_admin/screens/authentication_screen.dart';
import 'package:electric_admin/screens/login_screen.dart';
import 'package:electric_admin/screens/service_action.dart';
import 'package:electric_admin/screens/service_list_screen.dart';
import 'package:electric_admin/screens/otp_screen.dart';
import 'package:electric_admin/screens/signin_auth.dart';
import 'package:electric_admin/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AuthService.signOut();
  Get.put(AuthService(), tag: 'auth');
  Get.put(ServiceController(), tag: 'service');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        ServicesListScreen.ROUTE_NAME: (ctx) => ServicesListScreen(),
        ServiceActionScreen.ROUTE_NAME: (ctx) => ServiceActionScreen(),
        LoginScreen.ROUTE_NAME: (ctx) => LoginScreen(),
        SignInAuthScreen.ROUTE_NAME: (ctx) => SignInAuthScreen(),
        AuthenticationScreen.ROUTE_NAME: (ctx) => AuthenticationScreen(),
        OTPScreen.ROUTE_NAME: (ctx) => OTPScreen(),
      },
      initialRoute: AuthenticationScreen.ROUTE_NAME,
    );
  }
}
