import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/app_key.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/pages/home_page/home_page.dart';
import 'package:nps_social/pages/login_page/login_page.dart';
import 'package:nps_social/pages/nav_page.dart';
import 'package:nps_social/services/permission.dart';
import 'package:nps_social/services/socket_client.dart';
import 'package:nps_social/services/spref.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: '.env');
  await SPref.init();
  await initPermissions();
  AppKey.init();
  // await SocketClient.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NPS Social',
      home: GetBuilder<AuthController>(builder: (controller) {
        if (controller.auth != null) return const NavPage();
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

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
