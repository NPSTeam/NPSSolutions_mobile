import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/configs/themes/text_style_const.dart';
import 'package:npssolutions_mobile/controllers/note_detail_controller.dart';
import 'package:npssolutions_mobile/controllers/note_list_controller.dart';
import 'package:npssolutions_mobile/helpers/util_function.dart';
import 'package:npssolutions_mobile/models/note_task_model.dart';
import 'package:npssolutions_mobile/widgets/widget_checkbox_list_tile.dart';

import '../../../configs/themes/color_const.dart';
import '../../../widgets/widget_bouncing.dart';
import '../../../widgets/widget_text_field.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({super.key, required this.noteId});

  final int noteId;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final NoteDetailController _noteDetailController =
      Get.put(NoteDetailController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  late RestartableTimer _saveNoteTimer;

  bool isAddingTask = false;
  final TextEditingController _addTaskTitleController = TextEditingController();

  _loadData() async {
    EasyLoading.show();

    await _noteDetailController.getNoteDetail(widget.noteId);

    setState(() {
      _titleController.text = _noteDetailController.note?.title ?? '';
      _contentController.text = _noteDetailController.note?.content ?? '';
    });

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    _saveNoteTimer =
        RestartableTimer(const Duration(milliseconds: 500), () => saveNote());

    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteDetailController>(builder: (noteDetailController) {
      return GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConst.primary,
            centerTitle: true,
            title: const Text('Note Detail'),
            actions: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onSelected: (value) async {
                  if (value == 'DELETE') {
                    EasyLoading.show(status: 'Deleting...');
                    await _noteDetailController.deleteNote(widget.noteId);
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
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (_noteDetailController.note?.image != null &&
                          _noteDetailController.note?.image != '')
                        Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: _noteDetailController.note?.image ?? '',
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 10,
                              child: FloatingActionButton(
                                onPressed: () {
                                  _noteDetailController.note!.image = '';
                                  _noteDetailController
                                      .updateNote(_noteDetailController.note!);
                                },
                                mini: true,
                                backgroundColor: ColorConst.primary,
                                child: const Icon(Ionicons.trash_outline,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Title',
                              ),
                              style: TextStyleConst.boldStyle(fontSize: 24),
                              onChanged: (value) => _saveNoteTimer.reset(),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _contentController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Content',
                              ),
                              maxLines: 10,
                              onChanged: (value) => _saveNoteTimer.reset(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!UtilFunction.isShowKeyboard(context))
                      ...List.generate(
                        _noteDetailController.note?.tasks?.length ?? 0,
                        (index) => Row(
                          children: [
                            Expanded(
                              child: WidgetCheckboxListTile(
                                visualDensity: VisualDensity.compact,
                                value: _noteDetailController
                                    .note?.tasks?[index].completed,
                                onChanged: (value) async {
                                  setState(() {
                                    _noteDetailController
                                        .note?.tasks?[index].completed = value;
                                  });

                                  _saveNoteTimer.reset();
                                },
                                title: Text(_noteDetailController
                                        .note?.tasks?[index].content ??
                                    ''),
                              ),
                            ),
                            WidgetBouncing(
                              onTap: () {
                                setState(() {
                                  _noteDetailController.note?.tasks
                                      ?.removeAt(index);
                                });

                                _saveNoteTimer.reset();
                              },
                              child:
                                  const Icon(Ionicons.trash_outline, size: 20),
                            ),
                          ],
                        ),
                      ),
                    if (isAddingTask)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            WidgetBouncing(
                              onTap: () async {
                                setState(() {
                                  isAddingTask = false;

                                  _noteDetailController.note?.tasks?.add(
                                      NoteTaskModel(
                                          content: _addTaskTitleController.text,
                                          completed: false));
                                });

                                _saveNoteTimer.reset();
                              },
                              child: const Icon(Ionicons.add_outline, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _addTaskTitleController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Add task',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_noteDetailController.note?.reminder != null &&
                        !UtilFunction.isShowKeyboard(context))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Ionicons.time_outline, size: 20),
                                const SizedBox(width: 10),
                                Text(DateFormat('MMM d, yy - HH:mm').format(
                                    _noteDetailController.note!.reminder!)),
                                const SizedBox(width: 10),
                                WidgetBouncing(
                                  onTap: () async {
                                    await EasyLoading.show();
                                    _noteDetailController.note?.reminder = null;
                                    _noteDetailController.updateNote(
                                        _noteDetailController.note!);
                                    await EasyLoading.dismiss();
                                  },
                                  child: const Icon(
                                      Ionicons.close_circle_outline,
                                      size: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                _noteDetailController.note!.reminder =
                                    await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate:
                                      _noteDetailController.note!.reminder ??
                                          DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then((DateTime? date) async {
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          _noteDetailController
                                                  .note!.reminder ??
                                              DateTime.now()),
                                    );
                                    return DateTimeField.combine(date, time);
                                  } else {
                                    return _noteDetailController
                                            .note!.reminder ??
                                        DateTime.now();
                                  }
                                });

                                await EasyLoading.show();
                                await _noteDetailController
                                    .updateNote(_noteDetailController.note!);
                                await _noteDetailController
                                    .getNoteDetail(widget.noteId);
                                await EasyLoading.dismiss();
                              },
                              child: const Icon(Ionicons.notifications_outline),
                            ),
                            const SizedBox(width: 15),
                            InkWell(
                              onTap: () async {
                                XFile? imageXFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);

                                if (imageXFile == null) {
                                  return;
                                }

                                await EasyLoading.show(status: 'Uploading...');
                                _noteDetailController.note!.image =
                                    await UtilFunction.fileToBase64(
                                        File(imageXFile.path));
                                await _noteDetailController
                                    .updateNote(_noteDetailController.note!);
                                await _noteDetailController
                                    .getNoteDetail(widget.noteId);
                                await EasyLoading.dismiss();
                              },
                              child: const Icon(Ionicons.image_outline),
                            ),
                            const SizedBox(width: 15),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  isAddingTask = true;
                                });

                                // await EasyLoading.show(status: 'Uploading...');
                                // _noteDetailController.note!.image =
                                //     await UtilFunction.fileToBase64(
                                //         File(imageXFile.path));
                                // await _noteDetailController
                                //     .updateNote(_noteDetailController.note!);
                                // await _noteDetailController
                                //     .getNoteDetail(widget.noteId);
                                // await EasyLoading.dismiss();
                              },
                              child: const Icon(Ionicons.create_outline),
                            ),
                          ],
                        ),
                        Text(
                          'Edited ${DateFormat('MMM d, yy - HH:mm').format(_noteDetailController.note?.updatedAt ?? DateTime.now())}',
                          style: TextStyleConst.regularStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future saveNote() async {
    // if (_taskDetailFormKey.currentState?.validate() == false) {
    //   return;
    // }

    if (_titleController.text.trim().isEmpty) {
      return;
    }

    if (_noteDetailController.note != null) {
      _noteDetailController.note!.title = _titleController.text.trim();
      _noteDetailController.note!.content = _contentController.text.trim();

      _noteDetailController.updateNote(_noteDetailController.note!);
    }

    // if (_taskDetailController.task != null) {
    //   _taskDetailController.task!.title = _titleController.text.trim();
    //   _taskDetailController.task!.notes = _notesController.text.trim();
    //   _taskDetailController.task!.tags = _selectedTags;
    //   _taskDetailController.task!.dueDate = _dueDate;
    //   _taskDetailController.task!.priority = taskPriorityMap.entries
    //       .firstWhere((element) => element.value == _dropdownController.text)
    //       .key;

    //   _taskDetailController.updateTask(_taskDetailController.task!);
    // }
  }
}
