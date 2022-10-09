import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/pages/login_page/login_page.dart';

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
        Get.find<AuthController>()
            .logOut()
            .then((_) => Get.offAll(const LoginPage()));
      },
      child: Scaffold(
        body: Container(
          color: Colors.green,
          child: const Center(child: Text('Home Page')),
        ),
      ),
    );
  }
}
