import 'package:electric_admin/models/service.dart';
import 'package:electric_admin/providers/service_provider.dart';
import 'package:electric_admin/screens/service_list.dart';
import 'package:electric_admin/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class ServiceActionScreen extends StatefulWidget {
  static const ROUTE_NAME = 'ServiceActionScreen';
  @override
  _ServiceActionScreenState createState() => _ServiceActionScreenState();
}

class _ServiceActionScreenState extends State<ServiceActionScreen> {
  String _heading = "Add Service";
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_heading),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async => await _submit(context),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    _buildNameTextBox(context),
                    _buildPriceTextBox(context),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildNameTextBox(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Service Name',
      ),
      controller: _nameController,
      validator: (value) => validateServiceName(value),
      focusNode: _nameFocusNode,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_priceFocusNode);
      },
    );
  }

  Widget _buildPriceTextBox(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Service Amount',
      ),
      controller: _priceController,
      validator: (value) => validateServiceName(value),
      focusNode: _priceFocusNode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) async {
        await _submit(context);
      },
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      FocusScope.of(context).unfocus();
      final ServiceController serviceController = Get.find(tag: 'serviceController');
      Service service = Service(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        price: double.parse(_priceController.text),
      );
      try {
        serviceController.addEditService(service: service);
        Get.back();
      } on Exception catch (_) {
        Get.snackbar('Error', 'Error adding service. Please try again!!');
      }
      setState(() {
        _loading = false;
      });
    }
  }
}
