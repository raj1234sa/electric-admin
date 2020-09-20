import 'package:electric_admin/utils/constants.dart';
import 'package:flutter/material.dart';

Widget buildPrimaryButton({String title, Function onPress}) {
  return RaisedButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
    textColor: Colors.white,
    onPressed: onPress,
    color: kDarkBlueColor,
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  );
}
