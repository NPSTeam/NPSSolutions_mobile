// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:npssolutions_mobile/configs/spref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppKey {
  static late String BACKEND_URL;
  static late String BACKEND_SOCKJS_URL;

  static init() {
    BACKEND_URL = dotenv.env['BACKEND_URL'] ?? '';
    BACKEND_SOCKJS_URL = dotenv.env['BACKEND_SOCKJS_URL'] ?? '';

    SharedPreferences.getInstance().then((instance) async {
      await instance.setString(SPrefKey.backendUrl, BACKEND_URL);
    });
  }
}
