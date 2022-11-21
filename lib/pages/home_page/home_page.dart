import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/controllers/home_controller.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/home_page/components/suggestions.dart';
import 'package:nps_social/pages/home_page/components/widget_create_post_container.dart';

import 'components/post_container.dart';
import 'components/rooms.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  final AuthController _authController = Get.find();
  final HomeController _homeController = Get.find();

  bool isLoadingSuggestions = true;
  bool isLoadingPosts = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _homeController.getPosts().then(((value) {
      setState(() {
        isLoadingPosts = false;
      });
    }));

    _homeController.getSuggestions().then((value) {
      setState(() {
        isLoadingSuggestions = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get.find<AuthController>()
    //     .logOut()
    //     .then((_) => Get.offAll(() => const LoginPage()));
    super.build(context);

    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 50,
        onRefresh: () async {
          setState(() {
            isLoadingPosts = true;
          });
          _homeController.getPosts().then((value) async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              isLoadingPosts = false;
            });
          });

          setState(() {
            isLoadingSuggestions = true;
          });
          _homeController.getSuggestions().then((_) {
            setState(() {
              isLoadingSuggestions = false;
            });
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
                  color: ColorConst.blue,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2,
                ),
              ),
              centerTitle: false,
              floating: true,
              leading: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoadingPosts = true;
                  });
                  _homeController.getPosts().then((value) async {
                    await Future.delayed(const Duration(seconds: 1))
                        .then((value) {
                      setState(() {
                        isLoadingPosts = false;
                      });
                    });
                  });

                  setState(() {
                    isLoadingSuggestions = true;
                  });
                  _homeController.getSuggestions().then((_) {
                    setState(() {
                      isLoadingSuggestions = false;
                    });
                  });
                  debugPrint("Refresh");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              actions: [
                // WidgetCircleButton(
                //   icon: Icons.search,
                //   iconSize: 30.0,
                //   iconColor: Colors.black,
                //   onPressed: () => debugPrint("search"),
                // ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/search.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/messages.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
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
            // SliverPadding(
            //   padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            //   sliver: SliverToBoxAdapter(
            //     child: Stories(
            //       currentUser: _authController.currentUser,
            //       stories: [],
            //     ),
            //   ),
            // ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              sliver: SliverToBoxAdapter(
                child: isLoadingSuggestions
                    ? Container(
                        color: ColorConst.white,
                        height: 200,
                        child: const SpinKitThreeBounce(
                          color: ColorConst.blue,
                          size: 30,
                        ),
                      )
                    : const Suggestions(),
              ),
            ),
            isLoadingPosts
                ? const SliverPadding(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                    sliver: SliverToBoxAdapter(
                      child: SpinKitThreeBounce(
                        color: ColorConst.blue,
                        size: 30,
                      ),
                    ),
                  )
                : GetBuilder<HomeController>(
                    builder: (controller) => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return PostContainer(
                              post: controller.allPosts?[index] ?? PostModel());
                        },
                        childCount: controller.allPosts?.length ?? 0,
                      ),
                    ),
                  ),
            // GetBuilder<HomeController>(
            //   builder: (controller) {
            //     return ListView.builder(itemBuilder: (context, index) {
            //       return PostContainer(
            //           post: controller.allPosts?[index] ?? PostModel());
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
