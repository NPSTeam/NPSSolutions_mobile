import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/controllers/note_detail_controller.dart';

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
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  WidgetTextField(
                    controller: _titleController,
                    labelText: 'Title',
                    hintText: 'Title',
                    onChanged: (value) => _saveNoteTimer.reset(),
                  ),
                  const SizedBox(height: 10),
                  WidgetTextField(
                    controller: _contentController,
                    labelText: 'Content',
                    maxLines: 5,
                    hintText: 'Write something...',
                    onChanged: (value) => _saveNoteTimer.reset(),
                  ),
                ],
              ),
            ),
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
