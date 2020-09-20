import 'package:electric_admin/models/service.dart';
import 'package:electric_admin/providers/service_provider.dart';
import 'package:electric_admin/screens/service_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Container(
        child: GetBuilder<ServiceController>(
          init: ServiceController(),
          tag: 'serviceController',
          builder: (serviceController) {
            List<Service> serviceList = serviceController.list;
            return ListView.builder(
              itemBuilder: (context, index) {
                Service service = serviceList[index];
                return ListTile(
                  title: Text(service.name),
                );
              },
              itemCount: serviceList.length,
            );
          },
        ),
      ),
    );
  }
}
