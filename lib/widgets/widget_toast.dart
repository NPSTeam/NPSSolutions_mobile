import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WidgetToast {
  static showToast({
    required String message,
  }) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.blue,
        fontSize: 16.0);
  }
}
