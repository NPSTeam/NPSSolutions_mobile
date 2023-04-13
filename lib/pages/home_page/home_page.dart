import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/themes/assets_const.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/pages/home_page/components/drawer_component.dart';
import 'package:npssolutions_mobile/widgets/widget_app_bar_avatar.dart';

import '../../configs/string_const.dart';
import '../../configs/themes/color_const.dart';
import '../../controllers/my_drawer_controller.dart';
import 'task_tab/task_tab.dart';
import 'workspace_tab/workspace_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _buildTabs() {
    final theme = Theme.of(context);
    return GetBuilder<MyDrawerController>(
      init: MyDrawerController(),
      builder: (controller) {
        switch (controller.selectedTabId) {
          case 'WORKSPACE_MANAGEMENT':
            return const WorkspaceTab();
          case 'TASKS':
            return const TaskTab();
          default:
            return Text(
              'Not found page',
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final canvasColor = ColorConst.primary;
    const accentCanvasColor = Color(0xFF3E3E61);
    const white = Colors.white;
    const actionColor = Color(0xFF5F5FA7);

    final divider = Divider(color: white.withOpacity(0.3), height: 1);

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorConst.primary,
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
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
            ],
          ),
        ),
        appBar: AppBar(
          leading: InkWell(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsConst.npsLogo),
            ),
          ),
          actions: const [
            WidgetAppBarAvatar(),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Center(
            child: Text("Workspace",
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ),
        body: _buildTabs(),
      ),
    );
  }
}
