import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/themes/assets_const.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/widgets/widget_app_bar_avatar.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../configs/themes/color_const.dart';
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
        switch (_drawerController.selectedIndex) {
          case 0:
            return const WorkspaceTab();
          case 1:
            return Container(
              color: ColorConst.primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_drawerController.selectedIndex.toString(),
                        textScaleFactor: 10.0),
                    ElevatedButton(
                      child: const Text('Go To Page of index 1'),
                      onPressed: () {
                        Get.find<AuthController>().logout();
                      },
                    )
                  ],
                ),
              ),
            );
          case 2:
            return Container(
              color: ColorConst.primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_drawerController.selectedIndex.toString(),
                        textScaleFactor: 10.0),
                    ElevatedButton(
                      child: const Text('Go To Page of index 1'),
                      onPressed: () {
                        Get.find<AuthController>().logout();
                      },
                    )
                  ],
                ),
              ),
            );
          case 3:
            return Container(
              color: ColorConst.primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_drawerController.selectedIndex.toString(),
                        textScaleFactor: 10.0),
                    ElevatedButton(
                      child: const Text('Go To Page of index 1'),
                      onPressed: () {
                        Get.find<AuthController>().logout();
                      },
                    )
                  ],
                ),
              ),
            );
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
        drawer: SidebarX(
          controller: _drawerController,
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: canvasColor,
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(color: Colors.white),
            selectedTextStyle: const TextStyle(color: Colors.white),
            itemTextPadding: const EdgeInsets.only(left: 30),
            selectedItemTextPadding: const EdgeInsets.only(left: 30),
            itemDecoration:
                BoxDecoration(border: Border.all(color: canvasColor)),
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
          footerDivider: Column(
            children: [
              StreamBuilder(
                  stream: _drawerController.extendStream,
                  builder: (context, snapshot) {
                    return DropShadow(
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 10.0,
                      spread: 0.5,
                      opacity: 0.7,
                      child: AnimatedCrossFade(
                        duration: Duration(milliseconds: 500),
                        firstChild: Image.asset(AssetsConst.npsSolutionsBrand,
                            height: 50),
                        secondChild:
                            Image.asset(AssetsConst.npsLogo, height: 40),
                        crossFadeState: _drawerController.extended
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        // child: Image.asset(
                        //   _drawerController.extended
                        //       ? AssetsConst.npsSolutionsBrand
                        //       : AssetsConst.npsLogo,
                        //   height: 50,
                        // ),
                      ),
                    );
                  }),
              divider,
            ],
          ),
          headerBuilder: (context, extended) {
            return const SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: CircleAvatar(
                  radius: 42.0,
                  backgroundColor: Colors.blueGrey,
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                  ),
                ),
              ),
            );
          },
          items: [
            SidebarXItem(
              icon: Icons.home,
              label: 'Workspace Management',
              onTap: () {
                debugPrint('Hello');
              },
            ),
            const SidebarXItem(
              icon: Icons.search,
              label: 'Search',
            ),
            const SidebarXItem(
              icon: Icons.people,
              label: 'People',
            ),
            const SidebarXItem(
              icon: Icons.favorite,
              label: 'Favorites',
            ),
          ],
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
