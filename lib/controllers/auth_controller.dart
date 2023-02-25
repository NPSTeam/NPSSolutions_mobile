import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/spref_key.dart';
import 'package:npssolutions_mobile/models/auth_model.dart';
import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/pages/onboarding_page/onboarding_page.dart';
import 'package:npssolutions_mobile/repositories/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  AuthModel? auth;

  AuthController() {
    SharedPreferences.getInstance().then((instance) async {
      if (instance.getString(SPrefKey.accessToken) != null &&
          instance.getString(SPrefKey.refreshToken) != null) {
        auth = AuthModel(
          accessToken: instance.getString(SPrefKey.accessToken),
          refreshToken: instance.getString(SPrefKey.refreshToken),
        );

        debugPrint("ACCESS TOKEN - ${auth?.accessToken}");
        debugPrint("REFRESH TOKEN - ${auth?.refreshToken}");

        update();
      }
    });
  }

  Future<bool> updateTokenToLocal({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      auth?.accessToken = accessToken;
      auth?.refreshToken = refreshToken;

      await SharedPreferences.getInstance().then((instance) async {
        await instance.setString(SPrefKey.accessToken, auth?.accessToken ?? '');
        await instance.setString(
            SPrefKey.refreshToken, auth?.refreshToken ?? '');
      });
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    ResponseModel? response =
        await authRepo.login(username: username, password: password);

    if (response?.data != null) {
      auth = AuthModel.fromJson(response?.data);

      await SharedPreferences.getInstance().then((instance) async {
        await instance.setString(SPrefKey.accessToken, auth?.accessToken ?? '');
        await instance.setString(
            SPrefKey.refreshToken, auth?.refreshToken ?? '');
      });

      update();
      return true;
    }

    return false;
  }

  Future<bool> register({
    required String username,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required DateTime birthday,
    required String avatarFilePath,
  }) async {
    await authRepo.register(
      username: username,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      birthday: birthday,
      avatarFilePath: avatarFilePath,
    );

    return true;
  }

  Future<bool> logout() async {
    auth = null;

    await SharedPreferences.getInstance().then((instance) async {
      await instance.remove(SPrefKey.accessToken);
      await instance.remove(SPrefKey.refreshToken);
    });

    Get.offAll(const OnboardingPage());

    update();
    return true;
  }
}
