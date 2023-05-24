import 'dart:convert';
import 'dart:io';

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

  static Future<String> fileToBase64(File file) async {
    return "data:image/${p.extension(file.path).replaceFirst('.', '')};base64,${base64Encode(await file.readAsBytes())}";
  }
}
