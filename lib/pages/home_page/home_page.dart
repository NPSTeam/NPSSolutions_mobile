import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/themes/assets_const.dart';
import 'package:npssolutions_mobile/pages/home_page/ai_service_tab/ai_service_tab.dart';
import 'package:npssolutions_mobile/pages/home_page/calendar_tab/calendar_tab.dart';
import 'package:npssolutions_mobile/pages/home_page/components/drawer_component.dart';
import 'package:npssolutions_mobile/pages/home_page/note_tab/note_tab.dart';
import 'package:npssolutions_mobile/pages/home_page/scrumboard_tab/scrumboard_tab.dart';
import 'package:npssolutions_mobile/widgets/widget_app_bar_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/spref_key.dart';
import '../../configs/themes/color_const.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/my_drawer_controller.dart';
import '../../internationalization/message_keys.dart';
import '../../models/contact_model.dart';
import '../../repositories/chat_repo.dart';
import '../../services/in_app_message_notification_task.dart';
import 'chat_tab/chat_tab.dart';
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
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      // InAppMessageNotificationTask().execute();

      if (Get.find<AuthController>().auth == null) {
        return;
      }

      final response = await chatRepo.getContactList();
      if (response?.data != null) {
        List<ContactModel> contacts = (response?.data as List)
            .map((e) => ContactModel.fromJson(e))
            .toList();

        await SharedPreferences.getInstance().then((instance) async {
          await instance.setStringList(SPrefKey.contactIdList,
              contacts.map((e) => e.id?.toStringAsFixed(0) ?? '').toList());

          await instance.setStringList(SPrefKey.contactNameList,
              contacts.map((e) => e.name ?? '').toList());
        });
      }
    });

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
          actions: const [WidgetAppBarAvatar()],
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
          case DrawerTabId.NOTES:
            return const NoteTab();
          case DrawerTabId.TASKS:
            return const TaskTab();
          case DrawerTabId.SCRUM_BOARD:
            return const ScrumboardTab();
          case DrawerTabId.CALENDAR:
            return const CalendarTab();
          case DrawerTabId.CHAT:
            return const ChatTab();
          case DrawerTabId.AI_SERVICE:
            return const AISerivceTab();
          case DrawerTabId.WORKSPACE_MANAGEMENT:
            return const WorkspaceTab();
          default:
            return Text(MessageKeys.notFoundPage.tr,
                style: theme.textTheme.headlineSmall);
        }
      },
    );
  }

  String _getTitle() {
    switch (_drawerController.selectedTabId) {
      case DrawerTabId.NOTES:
        return MessageKeys.homeTitleNote.tr;
      case DrawerTabId.TASKS:
        return MessageKeys.homeTitleTask.tr;
      case DrawerTabId.SCRUM_BOARD:
        return MessageKeys.homeTitleScrumboard.tr;
      case DrawerTabId.CALENDAR:
        return 'Calendar';
      case DrawerTabId.MAIL:
        return MessageKeys.homeTitleMail.tr;
      case DrawerTabId.CHAT:
        return MessageKeys.homeTitleChat.tr;
      case DrawerTabId.AI_SERVICE:
        return MessageKeys.homeTitleAIService.tr;
      case DrawerTabId.WORKSPACE_MANAGEMENT:
        return MessageKeys.homeTitleWorkspace.tr;
      default:
        return MessageKeys.homeTitleUntitled.tr;
    }
  }
}
