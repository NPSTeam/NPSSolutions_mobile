import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/configs/themes/text_style_const.dart';
import 'package:npssolutions_mobile/controllers/note_detail_controller.dart';
import 'package:npssolutions_mobile/helpers/util_function.dart';

import '../../../configs/themes/color_const.dart';
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
              Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        XFile? imageXFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (imageXFile == null) {
                          return;
                        }

                        EasyLoading.show(status: 'Uploading...');
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
                    Text(
                      'Edited ${DateFormat('MMM d, yy - HH:mm').format(_noteDetailController.note?.updatedAt ?? DateTime.now())}',
                      style: TextStyleConst.regularStyle(fontSize: 12),
                    ),
                    const SizedBox(),
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
