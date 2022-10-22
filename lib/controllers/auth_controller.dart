// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/spref_key.dart';
import 'package:nps_social/models/auth_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/home_page.dart';
import 'package:nps_social/repositories/auth_repo.dart';
import 'package:nps_social/services/spref.dart';
import 'package:nps_social/widgets/widget_snackbar.dart';

class AuthController extends GetxController {
  UserModel? currentUser;
  String? accessToken;
  String? refreshToken;
  AuthModel? auth;

  AuthController() {
    init();
    checkLogin();
  }

  init() async {
    accessToken = SPref.instance.get(SPrefKey.ACCESS_TOKEN);
    refreshToken = SPref.instance.get(SPrefKey.REFRESH_TOKEN);
    debugPrint("access token - $accessToken");
    debugPrint("refresh token - $refreshToken");
  }

  bool isLoggedIn() {
    return accessToken != null;
  }

  Future logIn({
    required String email,
    required String password,
  }) async {
    auth = await authRepository.login(
      email: email,
      password: password,
    );

    if (auth?.accessToken != null) {
      currentUser = auth?.user;
      await SPref.instance.set(SPrefKey.ACCESS_TOKEN, auth?.accessToken ?? '');
      await SPref.instance
          .set(SPrefKey.REFRESH_TOKEN, auth?.refreshToken ?? '');
      Get.offAll(const HomePage());
    } else {
      WidgetSnackbar.showSnackbar(
        title: "Alert",
        message: "The email or password is incorrect.",
        icon: const Icon(Ionicons.alert_circle_outline),
      );
    }
    update();
  }

  Future logOut() async {
    accessToken = null;
    SPref.instance.clearAll();
    update();
  }

  Future checkLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    auth = await authRepository.checkLogin(
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
    );
    currentUser = auth?.user;
    update();
    FlutterNativeSplash.remove();
  }
}
