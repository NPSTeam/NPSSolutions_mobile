import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/login_page/login_page.dart';
import 'package:nps_social/pages/personal_profile_page/components/profile_post_list_widget.dart';
import 'package:nps_social/pages/personal_profile_page/components/profile_saved_list_widget.dart';
import 'package:nps_social/pages/personal_profile_page/components/profile_widget.dart';

import 'controllers/personal_profile_controller.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({super.key});

  @override
  State<PersonalProfilePage> createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage>
    with SingleTickerProviderStateMixin {
  final PersonalProfileController _profileController = Get.find();

  final UserModel? currentUser = Get.find<AuthController>().currentUser;
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
      body: GetBuilder<PersonalProfileController>(builder: (controller) {
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      position: PopupMenuPosition.under,
                      onSelected: (value) {
                        switch (value) {
                          case 'LOGOUT':
                            Get.find<AuthController>().logOut().then(
                                (_) => Get.offAll(() => const LoginPage()));
                        }
                      },
                      itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'LOGOUT',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("Logout"),
                                  Icon(Ionicons.log_out_outline),
                                ],
                              ),
                            ),
                          ]),
                ],
              ),
            ),
            ProfileWidget(
              imagePath:
                  controller.selectedUser?.avatar ?? currentUser?.avatar ?? '',
              onClicked: () {},
            ),
            const SizedBox(height: 24),
            buildAbout(controller.selectedUser ?? currentUser),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Divider(),
            ),
            const SizedBox(height: 15),
            ..._profileController.selectedUser?.id == currentUser?.id
                ? buildPost(currentUser)
                : [const ProfilePostListWidget()],
          ],
        );
      }),
    );
  }

  Widget buildAbout(UserModel? user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                user?.fullName ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'About',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (user?.mobile != null && user?.mobile?.trim() != '') ...[
              Text(
                user?.mobile ?? '',
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 10),
            ],
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
          onTap: (value) {
            setState(() {});
          },
          tabs: const [
            Tab(
              child: Text("Posts", style: TextStyle(color: Colors.black)),
            ),
            Tab(
              child: Text("Saved", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        _tabController.index == 0
            ? const ProfilePostListWidget()
            : const ProfileSavedListWidget(),
      ];
}
