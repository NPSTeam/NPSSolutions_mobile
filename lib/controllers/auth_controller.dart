import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/spref_key.dart';
import 'package:npssolutions_mobile/controllers/my_drawer_controller.dart';
import 'package:npssolutions_mobile/models/auth_model.dart';
import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/models/user_model.dart';
import 'package:npssolutions_mobile/pages/onboarding_page/onboarding_page.dart';
import 'package:npssolutions_mobile/repositories/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/user_repo.dart';

class AuthController extends GetxController {
  AuthModel? auth;

  AuthController() {
    init();
  }

  Future init() async {
    await SharedPreferences.getInstance().then((instance) async {
      if (instance.getString(SPrefKey.accessToken) != null &&
          instance.getString(SPrefKey.accessToken) != '' &&
          instance.getString(SPrefKey.refreshToken) != null &&
          instance.getString(SPrefKey.refreshToken) != '') {
        auth = AuthModel(
          accessToken: instance.getString(SPrefKey.accessToken),
          refreshToken: instance.getString(SPrefKey.refreshToken),
        );

        debugPrint("ACCESS TOKEN - ${auth?.accessToken}");
        debugPrint("REFRESH TOKEN - ${auth?.refreshToken}");

        getUserProfile();

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
        await instance.setString(SPrefKey.accessToken, accessToken);
        await instance.setString(SPrefKey.refreshToken, refreshToken);
      });

      update();
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
    ResponseModel? response = await authRepo.login(
      username: username,
      password: password,
      rememberMe: rememberMe,
    );

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
    ResponseModel? response = await authRepo.register(
      username: username,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      birthday: birthday,
      avatarFilePath: avatarFilePath,
    );

    if (response != null) {
      return true;
    }

    return false;
  }

  Future<bool> logout() async {
    auth = null;

    if (!EasyLoading.isShow) {
      await EasyLoading.show();
    }

    await SharedPreferences.getInstance().then((instance) async {
      await instance.remove(SPrefKey.accessToken);
      await instance.remove(SPrefKey.refreshToken);
    });

    await init();
    Get.offAll(() => const OnboardingPage());
    Get.delete<MyDrawerController>();

    await EasyLoading.dismiss();
    update();

    return true;
  }

  Future<bool> getUserProfile() async {
    ResponseModel? response = await userRepo.getUserProfile();

    if (response?.data != null) {
      auth?.currentUser = UserModel.fromJson(response?.data);

      update();
      return true;
    }

    return false;
  }
}
