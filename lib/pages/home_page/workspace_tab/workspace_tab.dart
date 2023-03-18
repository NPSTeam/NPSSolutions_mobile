import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';
import 'package:npssolutions_mobile/controllers/workspace_management_controller.dart';

import '../../../widgets/widget_search_field.dart';

class WorkspaceTab extends StatefulWidget {
  const WorkspaceTab({super.key});

  @override
  State<WorkspaceTab> createState() => _WorkspaceTabState();
}

class _WorkspaceTabState extends State<WorkspaceTab> {
  WorkspaceManagementController _workspaceManagementController =
      Get.put(WorkspaceManagementController());

  @override
  void initState() {
    _workspaceManagementController.getWorkspaces();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkspaceManagementController>(builder: (controller) {
      return Scaffold(
          backgroundColor: ColorConst.primary,
          body: SafeArea(
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Greet(),
                  // Date(),
                  SizedBox(
                    height: 25.0,
                  ),
                  WidgetSearchField(),
                  SizedBox(
                    height: 25.0,
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.blueAccent,
                          blurRadius: 10,
                          //offset: Offset.infinite,
                        ),
                      ],
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          35.0,
                        ),
                        topRight: Radius.circular(
                          35.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 6,
                              decoration: BoxDecoration(
                                color: ColorConst.lightPrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.workspaces?.length ?? 0,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    controller.workspaces?[index].name ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    controller.workspaces?[index].address ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    // controller
                                    //     .selectWorkspace(controller.workspaces[index]);
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          // const BottomSheetHeaderTitle(
                          //   titleText: 'Consultant',
                          // ),
                        ],
                      ),
                    )))
          ])));
    });
  }
}
