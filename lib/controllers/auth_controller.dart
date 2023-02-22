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
      auth = AuthModel(
        refreshToken: instance.getString(SPrefKey.refreshToken),
        accessToken: instance.getString(SPrefKey.accessToken),
      );

      update();
    });
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
        await instance.setString(
            SPrefKey.refreshToken, auth?.refreshToken ?? '');
        await instance.setString(SPrefKey.accessToken, auth?.accessToken ?? '');
      });

      update();
      return true;
    }

    return false;
  }

  Future<bool> logout() async {
    auth = null;

    await SharedPreferences.getInstance().then((instance) async {
      await instance.remove(SPrefKey.refreshToken);
      await instance.remove(SPrefKey.accessToken);
    });

    Get.offAll(const OnboardingPage());

    update();
    return true;
  }
}
