import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../configs/themes/color_const.dart';
import '../../../controllers/scrumboard_list_controller.dart';
import '../../../models/scrumboard_model.dart';
import 'scrumboard_board_page.dart';

class ScrumboardTab extends StatefulWidget {
  const ScrumboardTab({super.key});

  @override
  State<ScrumboardTab> createState() => _ScrumboardTabState();
}

class _ScrumboardTabState extends State<ScrumboardTab>
    with TickerProviderStateMixin {
  final ScrumboardListController _scrumboardListController =
      Get.put(ScrumboardListController());

  int? _selectedWorkspaceId;

  @override
  void initState() {
    EasyLoading.show();
    _scrumboardListController
        .getWorkspaces()
        .then((_) => EasyLoading.dismiss());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScrumboardListController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorConst.primary,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25.0),
                  Center(
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.workspaces?.length ?? 0,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            setState(() {
                              _selectedWorkspaceId =
                                  controller.workspaces?[index].id;
                            });
                            EasyLoading.show();
                            await _scrumboardListController
                                .getScrumboards(_selectedWorkspaceId!);
                            await EasyLoading.dismiss();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: _selectedWorkspaceId ==
                                      controller.workspaces?[index].id
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                controller.workspaces?[index].name ?? "",
                                style: TextStyle(
                                  color: _selectedWorkspaceId ==
                                          controller.workspaces?[index].id
                                      ? ColorConst.primary
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
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
                          child: _selectedWorkspaceId == null
                              ? const Center(child: Text('Select Workspace'))
                              : GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 12,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemCount:
                                      (controller.scrumboards?.length ?? 0) + 1,
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        (controller.scrumboards?.length ?? 0)) {
                                      return Card(
                                        clipBehavior: Clip.hardEdge,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: InkWell(
                                          onTap: () async {
                                            EasyLoading.show(
                                                status: 'Creating');

                                            if (_selectedWorkspaceId != null) {
                                              await controller
                                                  .createScrumboard(
                                                      _selectedWorkspaceId!)
                                                  .then((value) {
                                                if (value != null) {
                                                  EasyLoading.dismiss();
                                                  Get.to(
                                                    () => ScrumboardBoardPage(
                                                        scrumboardId:
                                                            value.id!),
                                                    transition:
                                                        Transition.cupertino,
                                                  );
                                                }
                                              });
                                            }

                                            EasyLoading.dismiss();
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Icon(
                                              Ionicons.add_circle_outline,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return _scrumboardListItem(
                                        controller.scrumboards![index]);
                                  },
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
      );
    });
  }

  Widget _scrumboardListItem(ScrumboardModel scrumboard) => Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            if (scrumboard.id != null) {
              Get.to(() => ScrumboardBoardPage(scrumboardId: scrumboard.id!),
                  transition: Transition.cupertino);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF818CF8)),
                  child: const Icon(Icons.dashboard_outlined,
                      size: 20, color: Color(0xFF3730A3)),
                ),
                const SizedBox(height: 10),
                Text(
                  scrumboard.title ?? '',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                    'Edited: ${timeago.format(scrumboard.lastActivity ?? DateTime.now(), locale: 'vi')}'),
              ],
            ),
          ),
        ),
      );
}
