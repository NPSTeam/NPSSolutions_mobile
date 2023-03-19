import 'package:auto_animated/auto_animated.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';
import 'package:npssolutions_mobile/controllers/workspace_management_controller.dart';

import '../../../helpers/utils.dart';
import '../../../widgets/widget_search_field.dart';

class WorkspaceTab extends StatefulWidget {
  const WorkspaceTab({super.key});

  @override
  State<WorkspaceTab> createState() => _WorkspaceTabState();
}

class _WorkspaceTabState extends State<WorkspaceTab> {
  WorkspaceManagementController _workspaceManagementController =
      Get.put(WorkspaceManagementController());

  bool isLoadingWorkspaces = true;

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
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // Greet(),
                      // Date(),
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
                                  : LiveList(
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
                                                  BorderRadius.circular(15.0)),
                                          clipBehavior: Clip.hardEdge,
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
                                              // controller
                                              //     .selectWorkspace(controller.workspaces[index]);
                                            },
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

  Widget loadingListItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CardLoading(
            height: 30,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            width: 100,
            margin: EdgeInsets.only(bottom: 10),
          ),
          CardLoading(
              height: 100,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              margin: EdgeInsets.only(bottom: 10)),
          CardLoading(
            height: 30,
            width: 200,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            margin: EdgeInsets.only(bottom: 10),
          ),
        ],
      ),
    );
  }
}
