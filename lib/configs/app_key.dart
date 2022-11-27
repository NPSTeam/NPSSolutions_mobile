// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppKey {
  static late String BACKEND_URL;
  static late String CLOUDINARY_NAME;
  static late String CLOUDINARY_UPDATE_PRESET;

  static init() {
    BACKEND_URL = dotenv.env['BACKEND_URL'] ?? '';
    CLOUDINARY_NAME = dotenv.env['CLOUDINARY_NAME'] ?? '';
    CLOUDINARY_UPDATE_PRESET = dotenv.env['CLOUDINARY_UPDATE_PRESET'] ?? '';
  }
}
