import 'package:auto_animated/auto_animated.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';
import 'package:npssolutions_mobile/controllers/workspace_management_controller.dart';
import 'package:npssolutions_mobile/models/workspace_model.dart';
import 'package:npssolutions_mobile/pages/home_page/workspace_tab/workspace_detail_page/workspace_detail_page.dart';
import 'package:npssolutions_mobile/widgets/widget_dialog_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../configs/string_const.dart';
import '../../../helpers/utils.dart';
import '../../../widgets/widget_refresher.dart';
import '../../../widgets/widget_search_field.dart';

class WorkspaceTab extends StatefulWidget {
  const WorkspaceTab({super.key});

  @override
  State<WorkspaceTab> createState() => _WorkspaceTabState();
}

class _WorkspaceTabState extends State<WorkspaceTab> {
  final WorkspaceManagementController _workspaceManagementController =
      Get.put(WorkspaceManagementController());

  bool isLoadingWorkspaces = true;

  final RoundedLoadingButtonController _createWorkspaceBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _deleteWorkspaceBtnController =
      RoundedLoadingButtonController();

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  final _serviceItemList = StringConst.serviceList
      .map((e) => MultiSelectItem<String>(e, e))
      .toList();
  List<String> _selectedServices = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (await _workspaceManagementController.getWorkspaces()) {
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
    _workspaceManagementController
        .getWorkspaces()
        .then((value) => setState(() => isLoadingWorkspaces = false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkspaceManagementController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorConst.primary,
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: const IconThemeData(size: 22.0),
            visible: true,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => debugPrint('OPENING DIAL'),
            onClose: () => debugPrint('DIAL CLOSED'),
            tooltip: 'Options',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: const CircleBorder(),
            animationDuration: const Duration(milliseconds: 200),
            children: [
              SpeedDialChild(
                  child: const Icon(Ionicons.add),
                  backgroundColor: ColorConst.primary,
                  label: 'Create Workspace',
                  onTap: () => showCreateWorkspaceDialog(context)),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 25.0),
                      WidgetSearchField(),
                      SizedBox(height: 25.0),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(color: Colors.blueAccent, blurRadius: 10)
                      ],
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: ColorConst.lightPrimary,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: isLoadingWorkspaces
                                  ? LiveList(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      physics: const BouncingScrollPhysics(),
                                      showItemInterval:
                                          const Duration(milliseconds: 20),
                                      showItemDuration:
                                          const Duration(milliseconds: 200),
                                      itemCount: 10,
                                      itemBuilder: animationItemBuilder(
                                        (index) => loadingListItem(),
                                      ),
                                    )
                                  : WidgetRefresher(
                                      controller: _refreshController,
                                      onRefresh: _onRefresh,
                                      onLoading: _onLoading,
                                      child: LiveList(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        physics: const BouncingScrollPhysics(),
                                        showItemInterval:
                                            const Duration(milliseconds: 20),
                                        showItemDuration:
                                            const Duration(milliseconds: 200),
                                        itemCount:
                                            controller.workspaces?.length ?? 0,
                                        itemBuilder: animationItemBuilder(
                                          (index) => Card(
                                            elevation: 5,
                                            shadowColor:
                                                Colors.grey.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            clipBehavior: Clip.hardEdge,
                                            child: Slidable(
                                              key: const ValueKey(4),
                                              direction: Axis.horizontal,
                                              startActionPane: ActionPane(
                                                motion: const DrawerMotion(),
                                                extentRatio: 0.3,
                                                children: [
                                                  SlidableAction(
                                                    backgroundColor: Colors.red,
                                                    icon: Ionicons.trash,
                                                    onPressed: (_) =>
                                                        showDeleteWorkspaceDialog(
                                                            context,
                                                            controller
                                                                    .workspaces?[
                                                                        index]
                                                                    .id ??
                                                                0),
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  controller.workspaces?[index]
                                                          .name ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  controller.workspaces?[index]
                                                          .code ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                    Icons.arrow_forward_ios),
                                                onTap: () {
                                                  Get.to(
                                                    () => WorkspaceDetailPage(
                                                      workspaceId: controller
                                                              .workspaces?[
                                                                  index]
                                                              .id ??
                                                          0,
                                                    ),
                                                    transition:
                                                        Transition.cupertino,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _createWorkspace() async {
    await _workspaceManagementController.createWorkspace(WorkspaceModel(
      code: _codeController.text,
      name: _nameController.text,
      address: _addressController.text,
      registerServices: _selectedServices,
    ));

    _createWorkspaceBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _createWorkspaceBtnController.reset();
    Get.back();
  }

  void _deleteWorkspace(int workspaceId) async {
    await _workspaceManagementController.deleteWorkspace(workspaceId);

    _deleteWorkspaceBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _deleteWorkspaceBtnController.reset();
    Get.back();
  }

  Future<dynamic> showCreateWorkspaceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return WidgetDialogOverlay(
                title: "Create Workspace",
                body: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Code",
                      ),
                      controller: _codeController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Name",
                      ),
                      controller: _nameController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Address",
                      ),
                      controller: _addressController,
                    ),
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text("Services"),
                      title: const Text("Services"),
                      items: _serviceItemList,
                      initialValue: _selectedServices,
                      onConfirm: (values) => _selectedServices = values.cast(),
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) =>
                            setState(() => _selectedServices.remove(value)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Flexible(
                          child: RoundedLoadingButton(
                            controller: RoundedLoadingButtonController(),
                            animateOnTap: false,
                            color: Colors.grey,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: RoundedLoadingButton(
                            controller: _createWorkspaceBtnController,
                            onPressed: _createWorkspace,
                            child: const Text('Create',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }

  Future<dynamic> showDeleteWorkspaceDialog(
      BuildContext context, int workspaceId) {
    return showDialog(
      context: context,
      builder: (_) => WidgetDialogOverlay(
        title: "Delete Workspace",
        body: Column(
          children: [
            const Text(
              "Are you sure you want to delete this workspace?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: RoundedLoadingButton(
                    controller: RoundedLoadingButtonController(),
                    animateOnTap: false,
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: RoundedLoadingButton(
                    controller: _deleteWorkspaceBtnController,
                    color: Colors.red,
                    onPressed: () => _deleteWorkspace(workspaceId),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
