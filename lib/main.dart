import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/app_key.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/pages/home_page.dart';
import 'package:nps_social/pages/landing_page.dart';
import 'package:nps_social/pages/login_page/login_page.dart';
import 'package:nps_social/services/permission.dart';
import 'package:nps_social/services/spref.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: '.env');
  await SPref.init();
  AppKey.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NPS Social',
      home: GetBuilder<AuthController>(builder: (controller) {
        if (controller.auth != null) return const HomePage();
        return const LoginPage();
      }),
    );
    //   FutureBuilder(
    //     future: _authController.checkLogin(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Container(
    //           decoration: const BoxDecoration(color: Colors.white),
    //         );
    //       }
    //       return _authController.isLoggedIn()
    //           ? const HomePage()
    //           : const LoginPage();
    //     },
    //   ),
    // );
  }
}
