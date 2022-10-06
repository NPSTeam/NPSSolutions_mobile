import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<AuthController>().isLoggedIn = false;
        Get.find<AuthController>().update();
      },
      child: Container(
        color: Colors.green,
      ),
    );
  }
}
