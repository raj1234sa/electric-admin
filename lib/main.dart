import 'package:electric_admin/screens/service_action.dart';
import 'package:electric_admin/screens/service_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'providers/service_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ServiceController().initServices();
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
      },
      initialRoute: ServicesListScreen.ROUTE_NAME,
    );
  }
}
