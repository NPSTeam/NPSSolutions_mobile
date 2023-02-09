// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppKey {
  static late String BACKEND_URL;

  static init() {
    BACKEND_URL = dotenv.env['BACKEND_URL'] ?? '';
  }
}
