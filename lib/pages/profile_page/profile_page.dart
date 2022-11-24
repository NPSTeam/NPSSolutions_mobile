import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/profile_page/components/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final UserModel? user = Get.find<AuthController>().currentUser;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          ProfileWidget(
            imagePath: user?.avatar ?? '',
            onClicked: () {},
          ),
          const SizedBox(height: 24),
          buildAbout(user),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Divider(),
          ),
          const SizedBox(height: 48),
          ...buildPost(user),
        ],
      ),
    );
  }

  Widget buildAbout(UserModel? user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (user?.mobile != null && user?.mobile?.trim() != '')
              Text(
                user?.mobile ?? '',
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            Text(
              user?.fullName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text("${user?.followers?.length ?? 0} followers"),
                const SizedBox(width: 20),
                Text("${user?.following?.length ?? 0} following"),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text("No address information"),
          ],
        ),
      );

  List<Widget> buildPost(UserModel? user) => [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text("Posts", style: TextStyle(color: Colors.black)),
            ),
            Tab(
              child: Text("Saved", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  Container(height: 100, color: Colors.red),
                ],
              ),
              Column(
                children: [
                  Container(height: 100, color: Colors.yellow),
                ],
              ),
            ],
          ),
        ),
      ];
}
