import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/themes/assets_const.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/pages/home_page/components/drawer_component.dart';
import 'package:npssolutions_mobile/widgets/widget_app_bar_avatar.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../configs/themes/color_const.dart';
import 'task_tab/task_tab.dart';
import 'workspace_tab/workspace_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late SidebarXController _drawerController;

  Widget _buildTabs() {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _drawerController,
      builder: (context, child) {
        final bool isAdmin = Get.find<AuthController>()
                .auth
                ?.currentUser
                ?.roles
                ?.where((e) => e == 'admin')
                .isNotEmpty ??
            false;

        switch (DrawerComponent.items[_drawerController.selectedIndex].label) {
          case 'Workspace Management':
            return const WorkspaceTab();
          case 'Tasks':
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
    _drawerController = SidebarXController(selectedIndex: 0, extended: true);

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
        drawer: DrawerComponent(drawerController: _drawerController),
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
