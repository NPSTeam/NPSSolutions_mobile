// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppKey {
  static String? BACKEND_URL;

  static init() {
    BACKEND_URL = dotenv.env['BACKEND_URL'];
  }
}
