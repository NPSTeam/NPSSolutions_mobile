import 'package:flutter/material.dart';
import 'package:npssolutions_mobile/configs/spref_key.dart';
import 'package:npssolutions_mobile/models/auth_model.dart';
import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio_repo.dart';

class AuthController extends ChangeNotifier {
  late BuildContext context;

  bool isAuthenticated = false;
  AuthModel? auth;

  AuthController(BuildContext context) {
    SharedPreferences.getInstance().then((instance) async {
      auth?.refreshToken = instance.getString(SPrefKey.refreshToken);
      auth?.accessToken = instance.getString(SPrefKey.accessToken);
      notifyListeners();
    });
  }

  Future<bool> loggedInCheck() async {
    await SharedPreferences.getInstance().then((instance) async {
      auth?.refreshToken = instance.getString(SPrefKey.refreshToken);
      auth?.accessToken = instance.getString(SPrefKey.accessToken);
      notifyListeners();
    });

    debugPrint(auth?.refreshToken);
    debugPrint(auth?.accessToken);

    if (auth?.refreshToken != null &&
        auth?.refreshToken != '' &&
        auth?.accessToken != null &&
        auth?.accessToken != '') {
      return true;
    }

    return false;
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    ResponseModel? response = await DioRepo.post(
      '/api/v1/auth/login',
      data: {
        "username": username,
        "password": password,
        "rememberMe": true,
      },
      unAuth: true,
    );

    if (response?.data != null) {
      auth = AuthModel.fromJson(response?.data);

      await SharedPreferences.getInstance().then((instance) {
        instance.setString(SPrefKey.refreshToken, auth?.refreshToken ?? '');
        instance.setString(SPrefKey.accessToken, auth?.accessToken ?? '');
      });

      notifyListeners();
    }

    return true;
  }
}
