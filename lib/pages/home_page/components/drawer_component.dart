import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/configs/string_const.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../configs/themes/assets_const.dart';
import '../../../controllers/my_drawer_controller.dart';

class DrawerComponent extends StatefulWidget {
  DrawerComponent({super.key});

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  final divider = Divider(color: Colors.white.withOpacity(0.3), height: 1);

  final AuthController _authController = Get.find();

  final MyDrawerController _drawerController = Get.find<MyDrawerController>();

  final List<DrawerTabItem> _drawerTabItems = [
    DrawerTabItem(
      id: DrawerTabId.TASKS,
      label: 'Tasks',
      icon: Ionicons.checkmark_circle_outline,
      onTap: () {
        Get.find<MyDrawerController>().selectTab(DrawerTabId.TASKS);
        Get.back();
      },
    ),
    DrawerTabItem(
      id: DrawerTabId.SCRUM_BOARD,
      label: 'Scrum Board',
      icon: Icons.calendar_view_week_outlined,
      onTap: () {
        Get.find<MyDrawerController>().selectTab(DrawerTabId.SCRUM_BOARD);
        Get.back();
      },
    ),
    DrawerTabItem(
      id: DrawerTabId.LOG_OUT,
      label: 'Log Out',
      icon: Ionicons.log_out_outline,
      onTap: () {
        Get.find<AuthController>().logout();
      },
    ),
  ];

  @override
  void initState() {
    if (_authController.auth?.currentUser?.roles
            ?.where((e) => e == "admin")
            .isNotEmpty ??
        false) {
      _drawerTabItems.insert(
        _drawerTabItems.length - 1,
        DrawerTabItem(
          id: 'SYSTEM',
          label: "System",
          icon: Ionicons.settings_outline,
          subItems: [
            DrawerTabItem(
              id: DrawerTabId.WORKSPACE_MANAGEMENT,
              label: "Workspace Management",
              icon: Ionicons.business_outline,
              onTap: () {
                Get.find<MyDrawerController>()
                    .selectTab(DrawerTabId.WORKSPACE_MANAGEMENT);
                Get.back();
              },
            ),
          ],
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorConst.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GetBuilder<AuthController>(builder: (controller) {
            return DrawerHeader(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(color: ColorConst.primary),
              child: Column(
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
                      radius: 40.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          Image.asset(AssetsConst.profileAvatarPlaceholder)
                              .image,
                      foregroundImage: NetworkImage(
                          controller.auth?.currentUser?.photoURL ??
                              StringConst.placeholderImageUrl),
                    ),
                  ),
                  Text(
                    controller.auth?.currentUser?.displayName ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.auth?.currentUser?.email ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            );
          }),
          divider,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: List.generate(
                _drawerTabItems.length,
                (index) => (_drawerTabItems[index].subItems?.isEmpty ?? true)
                    ? ListTile(
                        leading: Icon(_drawerTabItems[index].icon,
                            color: Colors.white),
                        title: Text(_drawerTabItems[index].label,
                            style: const TextStyle(color: Colors.white)),
                        onTap: () => _drawerTabItems[index].onTap!(),
                      )
                    : Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text(_drawerTabItems[index].label,
                              style: const TextStyle(color: Colors.white)),
                          leading: Icon(_drawerTabItems[index].icon,
                              color: Colors.white),
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          children: List.generate(
                            _drawerTabItems[index].subItems?.length ?? 0,
                            (subItemIndex) => Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: ListTile(
                                leading: Icon(
                                    _drawerTabItems[index]
                                        .subItems![subItemIndex]
                                        .icon,
                                    color: Colors.white),
                                title: Text(
                                    _drawerTabItems[index]
                                        .subItems![subItemIndex]
                                        .label,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                onTap: () => _drawerTabItems[index]
                                    .subItems![subItemIndex]
                                    .onTap!(),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(AssetsConst.npsSolutionsBrand, height: 50),
              ),
              divider,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData
                            ? 'v${snapshot.data!.version}'
                            : 'v0.0.0',
                        style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DrawerTabItem {
  final String id;
  final String label;
  final IconData icon;
  final Function? onTap;
  final List<DrawerTabItem>? subItems;

  DrawerTabItem({
    required this.id,
    required this.label,
    required this.icon,
    this.onTap,
    this.subItems,
  });
}

class DrawerTabId {
  static const String TASKS = 'TASKS';
  static const String SCRUM_BOARD = 'SCRUM_BOARD';
  static const String WORKSPACE_MANAGEMENT = 'WORKSPACE_MANAGEMENT';
  static const String LOG_OUT = 'LOG_OUT';
}
