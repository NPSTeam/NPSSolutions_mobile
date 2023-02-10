import 'package:flutter/material.dart';
import 'package:npssolutions_mobile/configs/spref_key.dart';
import 'package:npssolutions_mobile/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool isAuthenticated = false;
  AuthModel? auth;

  AuthController() {
    SharedPreferences.getInstance().then((instance) async {
      auth?.refreshToken = instance.getString(SPrefKey.refreshToken) ?? '';
      auth?.accessToken = instance.getString(SPrefKey.accessToken) ?? '';
      notifyListeners();
    });
  }

  Future refreshAuthentication() async {}
}
