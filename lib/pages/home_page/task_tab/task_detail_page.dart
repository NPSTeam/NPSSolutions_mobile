import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:npssolutions_mobile/controllers/task_detail_controller.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../configs/themes/color_const.dart';
import '../../../models/task_model.dart';
import '../../../widgets/widget_dialog_overlay.dart';
import '../../../widgets/widget_text_field.dart';

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

  @override
  void initState() {
    init();

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
  Widget build(BuildContext context) {
    return GetBuilder<TaskDetailController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.primary,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text("Task"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              WidgetTextField(
                controller: _titleController,
                labelText: 'Title',
                hintText: 'Title',
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MultiSelectBottomSheetField(
                      buttonIcon: const Icon(Ionicons.chevron_down_outline),
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text("Tags"),
                      title: const Text("Tags"),
                      items: controller.tagList
                              ?.map((e) => MultiSelectItem<int>(
                                  e.id ?? 0, e.title ?? ''))
                              .toList() ??
                          [],
                      initialValue: _selectedTags,
                      onConfirm: (values) => _selectedTags = values.cast(),
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
              CustomDropdown(
                hintText: "Priority",
                items: taskPriorityMap.entries.map((e) => e.value).toList(),
                controller: _dropdownController,
                listItemBuilder: (context, value) => Row(
                  children: [
                    if (value == 'Low')
                      const Icon(Ionicons.arrow_down_outline,
                          color: Colors.red),
                    if (value == 'Normal') const Icon(Ionicons.remove_outline),
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
              DateTimeField(
                format: DateFormat("yyyy-MM-dd HH:mm"),
                initialValue: _dueDate,
                decoration: const InputDecoration(
                  labelText: "Due Date",
                ),
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

                  return _dueDate;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: "Notes"),
                controller: _notesController,
                maxLines: 10,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _createTag(String name) async {
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
            TextFormField(
              controller: tagNameController,
              decoration: const InputDecoration(labelText: 'Tag name'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value?.isEmpty == true ? 'Tag name cannot be blank' : null,
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
                    color: Colors.red,
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
}
