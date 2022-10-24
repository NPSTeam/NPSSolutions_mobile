import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/palette.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/controllers/home_controller.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/home_page/components/stories.dart';
import 'package:nps_social/widgets/widget_circle_button.dart';
import 'package:nps_social/pages/home_page/components/widget_create_post_container.dart';

import 'components/post_container.dart';
import 'components/rooms.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Get.find<AuthController>()
    //     .logOut()
    //     .then((_) => Get.offAll(const LoginPage()));
    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 50,
        onRefresh: () async {
          _homeController.getPosts().then((value) async {
            await Future.delayed(const Duration(seconds: 1));
          });
          debugPrint("Refresh");
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              title: const Text(
                "NPS Social",
                style: TextStyle(
                  color: Palette.facebookBlue,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2,
                ),
              ),
              centerTitle: false,
              floating: true,
              actions: [
                WidgetCircleButton(
                  icon: Icons.search,
                  iconSize: 30.0,
                  iconColor: Colors.black,
                  onPressed: () => debugPrint("search"),
                ),
                WidgetCircleButton(
                  icon: Ionicons.chatbubbles_outline,
                  iconSize: 30.0,
                  iconColor: Colors.black,
                  onPressed: () => debugPrint("messenger"),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: WidgetCreatePostContainer(
                  currentUser: _authController.currentUser),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
              sliver: SliverToBoxAdapter(
                child: Rooms(onlineUsers: [UserModel(), UserModel()]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              sliver: SliverToBoxAdapter(
                child: Stories(
                  currentUser: _authController.currentUser,
                  stories: [],
                ),
              ),
            ),
            GetBuilder<HomeController>(
              builder: (controller) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final PostModel post =
                        controller.allPosts?[index] ?? PostModel();
                    return PostContainer(post: post);
                  },
                  childCount: controller.allPosts?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
