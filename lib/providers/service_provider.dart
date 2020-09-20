import 'package:electric_admin/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class ServiceController extends GetxController {
  List<Service> services = [];

  final CollectionReference _serviceRef =
      FirebaseFirestore.instance.collection('services');

  @override
  onInit() async {
    QuerySnapshot doc = await _serviceRef.get();
    List<Service> list = [];
    doc.docs.forEach((element) {
      list.add(Service.fromJson(element.data()));
    });
    services = list;
    update();
  }

  List<Service> get list {
    return services;
  }

  Future<void> initServices() async {
    QuerySnapshot doc = await _serviceRef.get();
    List<Service> list = [];
    doc.docs.forEach((element) {
      list.add(Service.fromJson(element.data()));
    });
    services = list;
    update();
  }

  Future<void> addEditService({@required Service service}) async {
    try {
      await _serviceRef.doc(service.id).set(service.toJson());
      initServices();
    } on Exception catch (e) {
      print(e);
    }
  }
}
