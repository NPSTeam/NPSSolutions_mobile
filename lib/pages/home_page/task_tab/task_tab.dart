import 'package:auto_animated/auto_animated.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/task_list_controller.dart';
import '../../../helpers/utils.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  final TaskListController _taskListController = Get.put(TaskListController());

  bool isLoadingTasks = true;

  List<DragAndDropList> _contents = [];

  @override
  void initState() {
    _taskListController.getTasks().then((value) {
      _contents = [
        DragAndDropList(
          children: _taskListController.tasks
                  ?.map((e) => DragAndDropItem(
                        child: Card(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                child: Text(
                                  e.title ?? '',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList() ??
              [],
        )
      ];

      setState(() => isLoadingTasks = false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskListController>(builder: (controller) {
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
                label: 'Add Task',
                onTap: () => {}),
            // onTap: () => showCreateWorkspaceDialog(context)),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25.0),
                    Text(
                      '${controller.remainingTasks ?? 0} remaining tasks',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
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
                            child: DragAndDropLists(
                              children: _contents,
                              onItemReorder: _onItemReorder,
                              onListReorder: (_, __) {},
                              listPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              lastItemTargetHeight: 8,
                              addLastItemTargetHeightToTop: true,
                              lastListTargetSize: 40,
                              itemDragHandle: const DragHandle(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Ionicons.menu_outline,
                                    color: Colors.blueGrey,
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
    });
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedTaskItem =
          _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedTaskItem);

      var movedTask = _taskListController.tasks?.removeAt(oldItemIndex);
      if (movedTask != null) {
        _taskListController.tasks?.insert(newItemIndex, movedTask);
        _taskListController.tasks
            ?.asMap()
            .forEach((index, value) => value.order = index);
      }
    });

    _taskListController.reorderTasks();
  }
}
