// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:nps_social/configs/spref_key.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/home_page.dart';
import 'package:nps_social/repositories/auth_repo.dart';
import 'package:nps_social/services/spref.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AuthController extends GetxController {
  UserModel? currentUser;
  String? currentUserAccessToken;

  AuthController() {
    init();
  }

  init() async {
    await getMe();
    print("access token - $currentUserAccessToken");
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
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
            message: "The email or password is incorrect."),
      );
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
    print(currentUserAccessToken);
    update();
    FlutterNativeSplash.remove();
  }
}
