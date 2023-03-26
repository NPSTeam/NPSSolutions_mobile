import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/controllers/workspace_detail_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../configs/themes/assets_const.dart';
import '../../../../configs/themes/color_const.dart';
import '../../../../helpers/utils.dart';

class WorkspaceUsersPage extends StatefulWidget {
  const WorkspaceUsersPage({super.key, required this.workspaceId});

  final int workspaceId;

  @override
  State<WorkspaceUsersPage> createState() => _WorkspaceUsersPageState();
}

class _WorkspaceUsersPageState extends State<WorkspaceUsersPage> {
  final WorkspaceDetailController _workspaceDetailController = Get.find();

  bool isLoadingUsers = true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (await _workspaceDetailController
        .getWorkspaceUsers(widget.workspaceId)) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    EasyLoading.show();
    _workspaceDetailController.getWorkspaceUsers(widget.workspaceId).then(
      (value) {
        if (value) {
          setState(() {
            isLoadingUsers = false;
          });
          EasyLoading.dismiss();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkspaceDetailController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.primary,
          title: Text(controller.workspace?.name ?? "Workspace Users"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Ionicons.create_outline),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: isLoadingUsers
              ? LiveList(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  physics: const BouncingScrollPhysics(),
                  showItemInterval: const Duration(milliseconds: 20),
                  showItemDuration: const Duration(milliseconds: 200),
                  itemCount: 10,
                  itemBuilder: animationItemBuilder(
                    (index) => loadingListItem(),
                  ),
                )
              : SmartRefresher(
                  physics: const BouncingScrollPhysics(),
                  controller: _refreshController,
                  header: const ClassicHeader(
                    idleText: 'Pull to refresh',
                    releaseText: 'Release to refresh',
                    refreshingText: 'Refreshing...',
                    completeText: 'Refreshed',
                    failedText: 'Refresh failed',
                    textStyle: TextStyle(color: Colors.black),
                    iconPos: IconPosition.top,
                    releaseIcon: Icon(Icons.arrow_upward, color: Colors.black),
                    refreshingIcon: Icon(Icons.refresh, color: Colors.black),
                    completeIcon: Icon(Icons.check, color: Colors.black),
                    failedIcon: Icon(Icons.close, color: Colors.black),
                  ),
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: (controller.workspaceUsers?.isEmpty ?? false)
                      ? const Text(
                          "Nothing here",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        )
                      : LiveList(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          physics: const BouncingScrollPhysics(),
                          showItemInterval: const Duration(milliseconds: 20),
                          showItemDuration: const Duration(milliseconds: 200),
                          itemCount: controller.workspaceUsers?.length ?? 0,
                          itemBuilder: animationItemBuilder(
                            (index) => workspaceUserListItem(controller, index),
                          ),
                        ),
                ),
        ),
      );
    });
  }

  Card workspaceUserListItem(WorkspaceDetailController controller, int index) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
              Image.asset(AssetsConst.profileAvatarPlaceholder).image,
          foregroundImage:
              NetworkImage(controller.workspaceUsers?[index].avatar ?? ''),
        ),
        title: Text(
          controller.workspaceUsers?[index].username ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.workspaceUsers?[index].email ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              controller.workspaceUsers![index].birthDay != null
                  ? DateFormat("dd/MM/yyyy")
                      .format(controller.workspaceUsers![index].birthDay!)
                  : '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              controller.workspaceUsers?[index].phoneNumber ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
