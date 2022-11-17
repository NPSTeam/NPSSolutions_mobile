import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/profile_page/components/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Get.find<AuthController>().currentUser;

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user?.avatar ?? '',
            onClicked: () {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          // Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          // NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }

  Widget buildName(UserModel? user) => Column(
        children: [
          Text(
            user?.fullName ?? '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? '',
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  // Widget buildUpgradeButton() => ButtonWidget(
  //       text: 'hehehe',
  //       onClicked: () {},
  //     );

  Widget buildAbout(UserModel? user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user?.mobile ?? '',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
