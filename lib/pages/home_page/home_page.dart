import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/configs/themes/assets_const.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/pages/home_page/components/drawer_component.dart';
import 'package:npssolutions_mobile/widgets/widget_app_bar_avatar.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  final MyDrawerController _drawerController = Get.put(MyDrawerController());

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
        drawer: DrawerComponent(),
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
          title: Center(
            child: GetBuilder<MyDrawerController>(builder: (context) {
              return Text(_getTitle(),
                  style: const TextStyle(fontWeight: FontWeight.w500));
            }),
          ),
        ),
        body: _buildTabs(),
      ),
    );
  }

  Widget _buildTabs() {
    final theme = Theme.of(context);
    return GetBuilder<MyDrawerController>(
      builder: (controller) {
        switch (controller.selectedTabId) {
          case DrawerTabId.TASKS:
            return const TaskTab();
          case DrawerTabId.WORKSPACE_MANAGEMENT:
            return const WorkspaceTab();
          default:
            return Text('Not found page', style: theme.textTheme.headlineSmall);
        }
      },
    );
  }

  String _getTitle() {
    switch (_drawerController.selectedTabId) {
      case DrawerTabId.TASKS:
        return 'Tasks';
      case DrawerTabId.SCRUM_BOARD:
        return 'Scrum Board';
      case DrawerTabId.WORKSPACE_MANAGEMENT:
        return 'Workspace';
      default:
        return 'Untitled';
    }
  }
}
