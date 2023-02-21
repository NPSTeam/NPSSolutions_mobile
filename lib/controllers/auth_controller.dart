import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/spref_key.dart';
import 'package:npssolutions_mobile/models/auth_model.dart';
import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/repositories/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  AuthModel? auth;

  AuthController() {
    SharedPreferences.getInstance().then((instance) async {
      auth?.refreshToken = instance.getString(SPrefKey.refreshToken);
      auth?.accessToken = instance.getString(SPrefKey.accessToken);
      update();
    });
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    ResponseModel? response =
        await authRepo.login(username: username, password: password);

    if (response?.data != null) {
      auth = AuthModel.fromJson(response?.data);

      await SharedPreferences.getInstance().then((instance) {
        instance.setString(SPrefKey.refreshToken, auth?.refreshToken ?? '');
        instance.setString(SPrefKey.accessToken, auth?.accessToken ?? '');
      });

      update();
    }

    return true;
  }
}
