import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<AuthController>().isLoggedIn = true;
        Get.find<AuthController>().update();
      },
      child: Container(
        color: Colors.red,
      ),
    );
  }
}
