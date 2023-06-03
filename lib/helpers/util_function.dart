import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class UtilFunction {
  static String dateTimeToString(
    DateTime? dateTime, {
    String format = 'dd/MM/yyyy – HH:mm',
  }) {
    if (dateTime == null) return '';

    return DateFormat(format).format(dateTime);
  }

  static Future<String> fileToBase64(File file, {bool isFile = false}) async {
    return "data:${isFile ? 'application/octet-stream' : 'image'}/${p.extension(file.path).replaceFirst('.', '')};base64,${base64Encode(await file.readAsBytes())}";
  }

  static bool isShowKeyboard(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }
}
