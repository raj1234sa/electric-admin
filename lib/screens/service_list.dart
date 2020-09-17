import 'package:electric_admin/screens/service_action.dart';
import 'package:flutter/material.dart';

class ServicesListScreen extends StatelessWidget {
  static const ROUTE_NAME = 'ServicesListScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.pushNamed(context, ServiceActionScreen.ROUTE_NAME),
          ),
        ],
      ),
    );
  }
}
