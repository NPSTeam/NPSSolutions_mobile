// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/spref_key.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/home_page.dart';
import 'package:nps_social/repositories/auth_repo.dart';
import 'package:nps_social/services/spref.dart';
import 'package:nps_social/widgets/widget_snackbar.dart';

class AuthController extends GetxController {
  UserModel? currentUser;
  String? currentUserAccessToken;

  AuthController() {
    init();
  }

  init() async {
    await getMe();
    debugPrint("access token - $currentUserAccessToken");
  }

  bool isLoggedIn() {
    return currentUserAccessToken != null;
  }

  Future logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    UserModel user = await authRepository.login(
      email: email,
      password: password,
    );

    if (user.accessToken != null) {
      currentUserAccessToken = currentUser?.accessToken;
      currentUser = user;
      await SPref.instance
          .set(SPrefKey.ACCESS_TOKEN, currentUser?.accessToken ?? '');
      Get.offAll(const HomePage());
    } else {
      WidgetSnackbar.showSnackbar(
        title: "Alert",
        message: "The email or password is incorrect.",
        icon: const Icon(Ionicons.alert_circle_outline),
      );
      // showTopSnackBar(
      //   context,
      //   const CustomSnackBar.error(
      //       message: "The email or password is incorrect."),
      //   displayDuration: const Duration(seconds: 1),
      // );
    }
    update();
  }

  Future logOut() async {
    currentUserAccessToken = null;
    SPref.instance.clearAll();
    update();
  }

  Future getMe() async {
    await Future.delayed(const Duration(seconds: 2));
    currentUserAccessToken = SPref.instance.get(SPrefKey.ACCESS_TOKEN);
    debugPrint(currentUserAccessToken);
    update();
    FlutterNativeSplash.remove();
  }
}
