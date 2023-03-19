import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/configs/string_const.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../../configs/themes/assets_const.dart';

class DrawerComponent extends StatelessWidget {
  DrawerComponent({super.key, required this.drawerController});

  final SidebarXController drawerController;

  final canvasColor = ColorConst.primary;
  final accentCanvasColor = const Color(0xFF3E3E61);
  final white = Colors.white;
  final actionColor = const Color(0xFF5F5FA7);

  final divider = Divider(color: Colors.white.withOpacity(0.3), height: 1);

  AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: drawerController,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: canvasColor, borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(color: Colors.white),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(border: Border.all(color: canvasColor)),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: actionColor.withOpacity(0.37)),
          gradient: LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.28), blurRadius: 30)
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 20),
      ),
      extendedTheme: SidebarXTheme(
        width: Get.width * 0.7,
        decoration: BoxDecoration(color: canvasColor),
        margin: const EdgeInsets.only(right: 10),
      ),
      headerBuilder: (context, extended) {
        return SafeArea(
          child: GetBuilder<AuthController>(builder: (controller) {
            return StreamBuilder(
                stream: drawerController.extendStream,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: drawerController.extended ? 40.0 : 20.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              controller.auth?.currentUser?.photoURL ??
                                  StringConst.placeholderImageUrl),
                        ),
                      ),
                      drawerController.extended
                          ? Text(
                              controller.auth?.currentUser?.displayName ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            )
                          : const SizedBox(),
                      ...drawerController.extended
                          ? [
                              const SizedBox(height: 4),
                              Text(
                                controller.auth?.currentUser?.email ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]
                          : [],
                    ],
                  );
                });
          }),
        );
      },
      items: const [
        SidebarXItem(icon: Ionicons.business, label: 'Workspace Management'),
        SidebarXItem(icon: Icons.search, label: 'Search'),
        SidebarXItem(icon: Icons.people, label: 'People'),
        SidebarXItem(icon: Icons.favorite, label: 'Favorites'),
        SidebarXItem(icon: Icons.settings, label: 'Settings'),
      ],
      footerDivider: Column(
        children: [
          StreamBuilder(
              stream: drawerController.extendStream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 500),
                    firstChild:
                        Image.asset(AssetsConst.npsSolutionsBrand, height: 50),
                    secondChild: Image.asset(AssetsConst.npsLogo, height: 40),
                    crossFadeState: drawerController.extended
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                );
              }),
          divider,
          FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData ? 'v${snapshot.data!.version}' : 'v0.0.0',
                  style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline),
                );
              }),
        ],
      ),
    );
  }
}
