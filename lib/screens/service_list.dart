import 'package:electric_admin/screens/service_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/service.dart';
import '../providers/service_provider.dart';
import '../providers/service_provider.dart';
import '../providers/service_provider.dart';
import '../providers/service_provider.dart';

class ServicesListScreen extends StatelessWidget {
  static const ROUTE_NAME = 'ServicesListScreen';

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController =
        Get.put(ServiceController(), tag: 'serviceController');
    final List<Service> services = serviceController.list;
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
          builder: (services) {
            List<Service> serviceList = services.list;
            print(serviceList.length);
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
