import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/state_manager.dart';
import 'package:nps_social/configs/spref_key.dart';
import 'package:nps_social/services/spref.dart';

class AuthController extends GetxController {
  String? currentUserId;

  AuthController() {
    init();
  }

  init() {
    getMe();
  }

  bool isLoggedIn() {
    return currentUserId != null;
  }

  logIn() async {
    currentUserId = 'awfpjowef';

    print(dotenv.env['BACKEND_URL']);
    if (currentUserId != null) {
      await SPref.instance.set(SPrefKey.USER_ID, currentUserId ?? '');
    }
    update();
  }

  logOut() {
    currentUserId = null;
    SPref.instance.clearAll();
    update();
  }

  Future getMe() async {
    await Future.delayed(const Duration(seconds: 2));
    currentUserId = SPref.instance.get(SPrefKey.USER_ID);
    print(currentUserId);
    update();
    FlutterNativeSplash.remove();
  }
}
