import 'package:async/async.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:npssolutions_mobile/controllers/task_detail_controller.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../configs/themes/color_const.dart';
import '../../../configs/themes/text_style_const.dart';
import '../../../helpers/util_function.dart';
import '../../../models/task_model.dart';
import '../../../widgets/widget_checkbox_list_tile.dart';
import '../../../widgets/widget_date_time_field.dart';
import '../../../widgets/widget_dialog_overlay.dart';
import '../../../widgets/widget_dropdown.dart';
import '../../../widgets/widget_multi_select_bottom_sheet_field.dart';
import '../../../widgets/widget_text_field.dart';
import '../../../widgets/widget_text_form_field.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key, required this.taskId});

  final int taskId;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TaskDetailController _taskDetailController =
      Get.put(TaskDetailController());

  final TextEditingController _titleController = TextEditingController();

  List<int> _selectedTags = [];
  final RoundedLoadingButtonController _createTagBtnController =
      RoundedLoadingButtonController();
  final TextEditingController _dropdownController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _dueDate;

  final _createTagFormKey = GlobalKey<FormState>();
  final _taskDetailFormKey = GlobalKey<FormState>();

  late RestartableTimer _saveTaskTimer;

  @override
  void initState() {
    init();

    _saveTaskTimer =
        RestartableTimer(const Duration(milliseconds: 500), () => saveTask());

    super.initState();
  }

  init() async {
    EasyLoading.show();

    await _taskDetailController.getTaskDetail(widget.taskId);
    await _taskDetailController.getTagList();

    setState(() {
      _titleController.text = _taskDetailController.task?.title ?? '';
      _selectedTags = _taskDetailController.task?.tags ?? [];
      _dropdownController.text =
          taskPriorityMap[_taskDetailController.task?.priority] ?? '';
      _dueDate = _taskDetailController.task?.dueDate;
      _notesController.text = _taskDetailController.task?.notes ?? '';
    });

    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    _saveTaskTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskDetailController>(builder: (controller) {
      return GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConst.primary,
            centerTitle: true,
            title: const Text("Task"),
            actions: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onSelected: (value) async {
                  if (value == 'DELETE') {
                    EasyLoading.show(status: 'Deleting...');
                    await _taskDetailController.deleteTask(widget.taskId);
                    await EasyLoading.dismiss();

                    Get.back();
                  }
                },
                itemBuilder: (_) {
                  return [
                    PopupMenuItem(
                      value: 'DELETE',
                      child: Row(
                        children: const [
                          Icon(Ionicons.trash_outline, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _taskDetailFormKey,
                child: Column(
                  children: [
                    WidgetCheckboxListTile(
                      title: Text('MARK AS COMPLETE',
                          style: TextStyleConst.mediumStyle()),
                      value: controller.task?.completed ?? false,
                      onChanged: (value) {
                        setState(() => controller.task?.completed = value);
                        _saveTaskTimer.reset();
                      },
                    ),
                    const SizedBox(height: 10),
                    WidgetTextFormField(
                      controller: _titleController,
                      labelText: 'Title',
                      hintText: 'Title',
                      validator: (value) => value?.isEmpty == true
                          ? 'Title cannot be blank'
                          : null,
                      onChanged: (value) => _saveTaskTimer.reset(),
                      onEditingComplete: () => _saveTaskTimer.reset(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: WidgetMultiSelectBottomSheetField(
                            buttonText: 'Tags',
                            title: const Text('Tags'),
                            initialValue: _selectedTags,
                            items: controller.tagList
                                    ?.map((e) => MultiSelectItem<int>(
                                        e.id ?? 0, e.title ?? ''))
                                    .toList() ??
                                [],
                            onConfirm: (values) {
                              _selectedTags = values.cast();
                              _saveTaskTimer.reset();
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              onTap: (value) =>
                                  setState(() => _selectedTags.remove(value)),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => showCreateTagDialog(context),
                          icon: const Icon(Ionicons.add_circle_outline),
                        ),
                      ],
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
                      onChanged: (value) => _saveTaskTimer.reset(),
                    ),
                    const SizedBox(height: 10),
                    WidgetDateTimeField(
                      controller: TextEditingController(
                          text: UtilFunction.dateTimeToString(_dueDate)),
                      initialValue: _dueDate,
                      labelText: 'Due Date',
                      onShowPicker: (context, currentValue) async {
                        _dueDate = await showDatePicker(
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

                        _saveTaskTimer.reset();
                        return _dueDate;
                      },
                    ),
                    const SizedBox(height: 10),
                    WidgetTextField(
                      controller: _notesController,
                      labelText: 'Notes',
                      hintText: 'Write something...',
                      minLines: 5,
                      onChanged: (value) => _saveTaskTimer.reset(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _createTag(String name) async {
    if (name.trim().isEmpty) {
      _createTagBtnController.reset();
      _createTagFormKey.currentState?.validate();
      return;
    }

    await _taskDetailController.createTag(name.trim());

    _createTagBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _createTagBtnController.reset();
    Get.back();
  }

  Future<dynamic> showCreateTagDialog(BuildContext context) {
    final TextEditingController tagNameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (_) => WidgetDialogOverlay(
        title: "Create Tag",
        body: Column(
          children: [
            Form(
              key: _createTagFormKey,
              child: WidgetTextFormField(
                controller: tagNameController,
                labelText: 'Tag Name',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value?.isEmpty == true ? 'Tag name cannot be blank' : null,
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
                    controller: _createTagBtnController,
                    color: ColorConst.primary,
                    onPressed: () => _createTag(tagNameController.text.trim()),
                    child: const Text('Add',
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

  Future saveTask() async {
    if (_taskDetailFormKey.currentState?.validate() == false) {
      return;
    }

    if (_taskDetailController.task != null) {
      _taskDetailController.task!.title = _titleController.text.trim();
      _taskDetailController.task!.notes = _notesController.text.trim();
      _taskDetailController.task!.tags = _selectedTags;
      _taskDetailController.task!.dueDate = _dueDate;
      _taskDetailController.task!.priority = taskPriorityMap.entries
          .firstWhere((element) => element.value == _dropdownController.text)
          .key;

      _taskDetailController.updateTask(_taskDetailController.task!);
    }
  }
}
