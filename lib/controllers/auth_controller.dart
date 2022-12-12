// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/spref_key.dart';
import 'package:nps_social/models/auth_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/login_page/login_page.dart';
import 'package:nps_social/pages/nav_page.dart';
import 'package:nps_social/repositories/auth_repo.dart';
import 'package:nps_social/services/socket_client.dart';
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
      await init();
      Get.offAll(() => const NavPage());
    } else {
      WidgetSnackbar.showSnackbar(
        title: "Alert",
        message: "The email or password is incorrect.",
        icon: const Icon(Ionicons.alert_circle_outline),
      );
    }

    await SocketClient.init(refreshToken: refreshToken ?? '');
    update();
  }

  Future checkLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    auth = await authRepository.checkLogin(
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
    );
    currentUser = auth?.user;
    debugPrint(currentUser?.email);

    await SocketClient.init(refreshToken: refreshToken ?? '');

    update();
    FlutterNativeSplash.remove();
  }

  Future<UserModel?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobile,
    required String sex,
  }) async {
    if (firstName == '' ||
        lastName == '' ||
        email == '' ||
        password == '' ||
        mobile == '' ||
        sex == '') {
      WidgetSnackbar.showSnackbar(
        title: "Invalid",
        message: "Please completely enter your info.",
        icon: const Icon(Ionicons.alert_circle_outline),
      );
      return null;
    } else if (firstName.length > 15) {
      WidgetSnackbar.showSnackbar(
        title: "Invalid",
        message: "The maximum length of First Name is 15.",
      );
      return null;
    } else if (lastName.length > 30) {
      WidgetSnackbar.showSnackbar(
        title: "Invalid",
        message: "The maximum length of Last Name is 30.",
      );
      return null;
    } else if (!RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$')
        .hasMatch(email)) {
      WidgetSnackbar.showSnackbar(
        title: "Invalid",
        message: "The email is invalid.",
      );
      return null;
    } else if (password.length < 6) {
      WidgetSnackbar.showSnackbar(
        title: "Invalid",
        message: "Password must be at least 6 characters.",
      );
      return null;
    } else if (!RegExp(r'\d').hasMatch(password) ||
        !RegExp(r'[A-Z]').hasMatch(password)) {
      WidgetSnackbar.showSnackbar(
        title: "Invalid",
        message:
            "Password must contain at least 1 uppercase letter and 1 number.",
      );
      return null;
    }

    UserModel? user = await authRepository.register(
      firstName: firstName,
      lastName: lastName,
      fullName: '$firstName $lastName',
      email: email,
      password: password,
      mobile: mobile,
      sex: sex,
    );

    if (user != null) {
      return user;
    } else {
      WidgetSnackbar.showSnackbar(
        title: "Alert",
        message: "Something is wrong.",
        icon: const Icon(Ionicons.alert_circle_outline),
      );
      return null;
    }
  }

  Future sendVerificationEmail({
    required UserModel user,
  }) async {
    String? message = await authRepository.sendVerificationEmail(user: user);
    if (message != null) {
      Get.offAll(() => const LoginPage());
      WidgetSnackbar.showSnackbar(
        title: "Success",
        message: message,
        icon: const Icon(Ionicons.checkmark_circle_outline),
      );
    } else {
      WidgetSnackbar.showSnackbar(
        title: "Alert",
        message: "Something is wrong.",
        icon: const Icon(Ionicons.alert_circle_outline),
      );
    }
  }

  Future logOut() async {
    accessToken = null;
    SPref.instance.clearAll();
    update();
  }
}
