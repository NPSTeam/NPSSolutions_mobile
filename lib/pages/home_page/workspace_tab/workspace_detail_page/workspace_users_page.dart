import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/controllers/workspace_detail_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../configs/themes/assets_const.dart';
import '../../../../configs/themes/color_const.dart';
import '../../../../helpers/utils.dart';
import '../../../../widgets/widget_dialog_overlay.dart';

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

  final RoundedLoadingButtonController _updateWorkspaceUserBtnController =
      RoundedLoadingButtonController();

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
          onPressed: () => showCheckedUsersDialog(context).then(
              (_) => _workspaceDetailController.workspaceCheckedUsers = null),
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

  Future<dynamic> showCheckedUsersDialog(BuildContext context) {
    bool isLoadingCheckedUsers = true;

    final RefreshController refreshController =
        RefreshController(initialRefresh: false);

    void onRefresh() async {
      if (await _workspaceDetailController
          .getWorkspaceCheckedUsers(widget.workspaceId)) {
        refreshController.refreshCompleted();
      } else {
        refreshController.refreshFailed();
      }
    }

    void onLoading(
      void Function(void Function()) setState,
    ) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) setState(() {});
      refreshController.loadComplete();
    }

    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              if (_workspaceDetailController.workspaceCheckedUsers == null) {
                _workspaceDetailController
                    .getWorkspaceCheckedUsers(widget.workspaceId)
                    .then(
                  (value) {
                    if (value) {
                      setState(() {
                        isLoadingCheckedUsers = false;
                      });
                    }
                  },
                );
              }

              return GetBuilder<WorkspaceDetailController>(
                  builder: (controller) {
                return WidgetDialogOverlay(
                  title: "Users",
                  body: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Get.width * 0.85,
                      maxHeight: Get.height * 0.5,
                    ),
                    child: isLoadingCheckedUsers
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
                            controller: refreshController,
                            header: const ClassicHeader(
                              idleText: 'Pull to refresh',
                              releaseText: 'Release to refresh',
                              refreshingText: 'Refreshing...',
                              completeText: 'Refreshed',
                              failedText: 'Refresh failed',
                              textStyle: TextStyle(color: Colors.black),
                              iconPos: IconPosition.top,
                              releaseIcon:
                                  Icon(Icons.arrow_upward, color: Colors.black),
                              refreshingIcon:
                                  Icon(Icons.refresh, color: Colors.black),
                              completeIcon:
                                  Icon(Icons.check, color: Colors.black),
                              failedIcon:
                                  Icon(Icons.close, color: Colors.black),
                            ),
                            onRefresh: onRefresh,
                            onLoading: () => onLoading(setState),
                            child: (controller.workspaceCheckedUsers?.isEmpty ??
                                    false)
                                ? const Text(
                                    "Nothing here",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic),
                                  )
                                : LiveList(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    physics: const BouncingScrollPhysics(),
                                    showItemInterval:
                                        const Duration(milliseconds: 20),
                                    showItemDuration:
                                        const Duration(milliseconds: 200),
                                    itemCount: controller
                                            .workspaceCheckedUsers?.length ??
                                        0,
                                    itemBuilder: animationItemBuilder(
                                      (index) => workspaceCheckedUserListItem(
                                          controller, index, setState),
                                    ),
                                  ),
                          ),
                  ),
                  bottom: RoundedLoadingButton(
                    controller: _updateWorkspaceUserBtnController,
                    onPressed: _updateWorkspaceUser,
                    child: const Text('Save',
                        style: TextStyle(color: Colors.white)),
                  ),
                );
              });
            }));
  }

  Card workspaceCheckedUserListItem(
    WorkspaceDetailController controller,
    int index,
    void Function(void Function()) setState,
  ) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior: Clip.hardEdge,
      child: CheckboxListTile(
        value: controller.workspaceCheckedUsers?[index].checked ?? false,
        onChanged: (value) => {
          setState(() {
            controller.workspaceCheckedUsers?[index].checked = value;
          })
        },
        secondary: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
              Image.asset(AssetsConst.profileAvatarPlaceholder).image,
          foregroundImage: NetworkImage(
              controller.workspaceCheckedUsers?[index].avatar ?? ''),
        ),
        title: Text(
          controller.workspaceCheckedUsers?[index].username ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.workspaceCheckedUsers?[index].email ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              controller.workspaceCheckedUsers![index].birthDay != null
                  ? DateFormat("dd/MM/yyyy").format(
                      controller.workspaceCheckedUsers![index].birthDay!)
                  : '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              controller.workspaceCheckedUsers?[index].phoneNumber ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateWorkspaceUser() async {
    await _workspaceDetailController
        .updateWorkspaceUsers(
            widget.workspaceId,
            _workspaceDetailController.workspaceCheckedUsers
                    ?.where((e) => e.checked == true)
                    .toList() ??
                [])
        .then((success) {
      if (success) {
        _updateWorkspaceUserBtnController.success();
      } else {
        _updateWorkspaceUserBtnController.error();
      }
      Future.delayed(const Duration(seconds: 1), () {
        _updateWorkspaceUserBtnController.reset();
      });
    });
  }
}
