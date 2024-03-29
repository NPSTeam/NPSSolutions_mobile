import 'package:async/async.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:npssolutions_mobile/models/task_model.dart';
import 'package:npssolutions_mobile/pages/home_page/task_tab/task_detail_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/task_list_controller.dart';
import '../../../internationalization/message_keys.dart';
import '../../../widgets/widget_checkbox_list_tile.dart';
import '../../../widgets/widget_date_time_field.dart';
import '../../../widgets/widget_dialog_overlay.dart';
import '../../../widgets/widget_dropdown.dart';
import '../../../widgets/widget_refresher.dart';
import '../../../widgets/widget_text_field.dart';
import '../../../widgets/widget_text_form_field.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  final TaskListController _taskListController = Get.put(TaskListController());

  bool isLoadingTasks = true;

  List<DragAndDropList> _contents = [];

  late RestartableTimer _updateTaskOrderTimer;

  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  List<int> _selectedTags = [];

  final RoundedLoadingButtonController _createTaskBtnController =
      RoundedLoadingButtonController();

  bool completed = false;
  DateTime? dueDate;

  final TextEditingController _dropdownController =
      TextEditingController(text: 'Normal');

  final RoundedLoadingButtonController _deleteTaskBtnController =
      RoundedLoadingButtonController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (await _taskListController.getTasks()) {
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
    _taskListController.getTasks().then((value) {
      EasyLoading.dismiss();
      setState(() => isLoadingTasks = false);
    });

    _updateTaskOrderTimer = RestartableTimer(
        const Duration(seconds: 1), () => _taskListController.reorderTasks());
    _updateTaskOrderTimer.cancel();

    super.initState();
  }

  @override
  void dispose() {
    _updateTaskOrderTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskListController>(builder: (controller) {
      _contents = [
        DragAndDropList(
          canDrag: false,
          children: controller.tasks
                  ?.map((e) => DragAndDropItem(
                        child: InkWell(
                          onTap: () => Get.to(
                                  () => TaskDetailPage(taskId: e.id!),
                                  transition: Transition.cupertino)
                              ?.then((_) async {
                            EasyLoading.show();
                            await _taskListController.getTasks();
                            EasyLoading.dismiss();
                          }),
                          onLongPress: () =>
                              showDeleteTaskDialog(context, e.id!),
                          child: e.type == 'task'
                              ? Card(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 12),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              e.completed =
                                                  !(e.completed ?? false);
                                            });

                                            controller
                                                .updateTask(e)
                                                .then((value) {
                                              if (value) {
                                                controller
                                                    .updateRemainingTasks();
                                              }
                                            });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Icon(
                                            Ionicons.checkmark_circle,
                                            color: e.completed == true
                                                ? ColorConst.primary
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 12),
                                          child: Text(
                                            e.title ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 12),
                                        child: Text(e.title ?? ''),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ))
                  .toList() ??
              [],
        )
      ];

      return Scaffold(
        backgroundColor: ColorConst.primary,
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          visible: true,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: const CircleBorder(),
          animationDuration: const Duration(milliseconds: 200),
          children: [
            SpeedDialChild(
              child: const Icon(Ionicons.add, color: Colors.white),
              backgroundColor: ColorConst.primary,
              label: MessageKeys.addTask.tr,
              onTap: () => showCreateDialog(context, true),
            ),
            SpeedDialChild(
              child: const Icon(Ionicons.add),
              backgroundColor: Colors.white,
              label: MessageKeys.addSection.tr,
              onTap: () => showCreateDialog(context, false),
            ),
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
                      MessageKeys.remainingTasks.trParams(
                          {'value': '${controller.remainingTasks ?? 0}'}),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
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
                        topRight: Radius.circular(35.0)),
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
                            child: WidgetRefresher(
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              child: DragAndDropLists(
                                children: _contents,
                                onItemReorder: _onItemReorder,
                                onListReorder: (_, __) {},
                                listPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                onItemDraggingChanged: (item, isDragging) {
                                  HapticFeedback.lightImpact();
                                },
                                listDragOnLongPress: false,
                                lastItemTargetHeight: 8,
                                addLastItemTargetHeightToTop: true,
                                lastListTargetSize: 40,
                                itemDragHandle: const DragHandle(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Ionicons.menu_outline,
                                        color: Colors.blueGrey),
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

    _updateTaskOrderTimer.reset();
  }

  Future<dynamic> showCreateDialog(BuildContext context, bool isCreateTask) {
    completed = false;
    _titleController.clear();
    _notesController.clear();
    _dropdownController.text = 'Normal';
    dueDate = null;
    _selectedTags = [];
    _taskListController.getTags();

    return showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return WidgetDialogOverlay(
            title: "Create ${isCreateTask ? "Task" : "Section"}",
            body: SizedBox(
              height: Get.height * 0.4,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    WidgetCheckboxListTile(
                      title: const Text('Mark as complete',
                          style: TextStyle(fontSize: 16)),
                      value: completed,
                      onChanged: (value) =>
                          setState(() => completed = value ?? false),
                    ),
                    const SizedBox(height: 10),
                    WidgetTextFormField(
                      controller: _titleController,
                      labelText: '${isCreateTask ? "Task" : "Section"} Title',
                    ),
                    const SizedBox(height: 10),
                    WidgetDropdown(
                      hintText: 'Priority',
                      items:
                          taskPriorityMap.entries.map((e) => e.value).toList(),
                      controller: _dropdownController,
                      listItemBuilder: (context, value) => Row(
                        children: [
                          if (value == 'Low')
                            const Icon(Ionicons.arrow_down_outline,
                                color: Colors.red),
                          if (value == 'Normal')
                            const Icon(Ionicons.remove_outline),
                          if (value == 'High')
                            const Icon(Ionicons.arrow_up_outline,
                                color: Colors.green),
                          const SizedBox(width: 5),
                          Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GetBuilder<TaskListController>(builder: (controller) {
                      return MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: const Text('Tags'),
                        title: const Text('Tags'),
                        items: controller.tags
                                ?.map((e) =>
                                    MultiSelectItem<int>(e.id!, e.title!))
                                .toList() ??
                            [],
                        initialValue: _selectedTags,
                        onConfirm: (values) => _selectedTags = values.cast(),
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) =>
                              setState(() => _selectedTags.remove(value)),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    WidgetDateTimeField(
                      labelText: 'Due Date',
                      onShowPicker: (context, currentValue) async {
                        dueDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((DateTime? date) async {
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue ?? DateTime.now();
                          }
                        });

                        return dueDate;
                      },
                    ),
                    const SizedBox(height: 10),
                    WidgetTextField(
                      controller: _notesController,
                      labelText: 'Notes',
                      minLines: 5,
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
                            controller: _createTaskBtnController,
                            onPressed: () => _createTask(isCreateTask),
                            child: const Text('Create',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _createTask(bool isCreateTask) async {
    await _taskListController.createTask(TaskModel(
      type: isCreateTask ? "task" : "section",
      title: _titleController.text,
      notes: _notesController.text,
      tags: _selectedTags,
      completed: completed,
      dueDate: dueDate,
      priority: taskPriorityMap.entries
          .singleWhere((element) => element.value == _dropdownController.text)
          .key,
    ));

    _createTaskBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _createTaskBtnController.reset();
    Get.back();
  }

  Future<dynamic> showDeleteTaskDialog(BuildContext context, int taskId) {
    return showDialog(
      context: context,
      builder: (_) => WidgetDialogOverlay(
        title: "Delete Task",
        body: Column(
          children: [
            const Text(
              "Are you sure you want to delete this task?",
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
                    controller: _deleteTaskBtnController,
                    color: Colors.red,
                    onPressed: () => _deleteTask(taskId),
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

  void _deleteTask(int taskId) async {
    await _taskListController.deleteTask(taskId);

    _deleteTaskBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _deleteTaskBtnController.reset();
    Get.back();
  }
}
