import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/pages/home_page.dart';
import 'package:nps_social/pages/login_page/login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AuthController _authController = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: _authController.isLoggedIn(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         FlutterNativeSplash.remove();
    //         if (snapshot.data == true) return const HomePage();
    //         return const LoginPage();
    //       }
    //       return Container();
    //     });
    return GetBuilder<AuthController>(
      builder: (controller) =>
          controller.isLoggedIn() ? const HomePage() : const LoginPage(),
    );
  }
}
