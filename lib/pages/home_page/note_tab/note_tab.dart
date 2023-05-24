import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/note_list_controller.dart';
import '../../../internationalization/message_keys.dart';
import '../../../models/note_model.dart';
import '../../../widgets/widget_dialog_overlay.dart';
import '../../../widgets/widget_refresher.dart';
import '../../../widgets/widget_text_field.dart';
import '../../../widgets/widget_text_form_field.dart';
import 'note_detail_page.dart';

class NoteTab extends StatefulWidget {
  const NoteTab({super.key});

  @override
  State<NoteTab> createState() => _NoteTabState();
}

class _NoteTabState extends State<NoteTab> {
  final NoteListController _noteListController = Get.put(NoteListController());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final RoundedLoadingButtonController _createNoteBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _deleteNoteBtnController =
      RoundedLoadingButtonController();

  loadData() async {
    EasyLoading.show();
    await _noteListController.getNotes();
    EasyLoading.dismiss();
  }

  void _onRefresh() async {
    if (await _noteListController.getNotes()) {
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
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteListController>(builder: (noteListController) {
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
              child: const Icon(Ionicons.add),
              backgroundColor: ColorConst.primary,
              label: 'Add Note',
              onTap: () => showCreateNoteDialog(context),
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
                  children: const [
                    SizedBox(height: 25.0),
                    Text(
                      'Search your notes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
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
                            padding: const EdgeInsets.only(top: 10.0),
                            child: WidgetRefresher(
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              child: MasonryGridView.count(
                                physics: const BouncingScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                itemCount:
                                    noteListController.notes?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return _noteItem(index, noteListController);
                                },
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

  Widget _noteItem(int index, NoteListController noteListController) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: InkWell(
        onTap: () {
          if (noteListController.notes?[index].id != null) {
            Get.to(
                () => NoteDetailPage(
                    noteId: noteListController.notes![index].id!),
                transition: Transition.zoom);
          }
        },
        onLongPress: () =>
            showDeleteNoteDialog(context, noteListController.notes![index].id!),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: Random().nextDouble() * 100 + 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (noteListController.notes?[index].image != null &&
                  noteListController.notes?[index].image != '')
                CachedNetworkImage(
                  imageUrl: noteListController.notes?[index].image ?? '',
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  noteListController.notes?[index].title ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    noteListController.notes?[index].content ?? '',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCreateNoteDialog(BuildContext context) {
    _titleController.clear();
    _contentController.clear();

    return showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return WidgetDialogOverlay(
            title: "Add Note",
            body: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height * 0.4),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    WidgetTextFormField(
                      controller: _titleController,
                      labelText: 'Title',
                    ),
                    // const SizedBox(height: 10),
                    // GetBuilder<TaskListController>(builder: (controller) {
                    //   return MultiSelectBottomSheetField(
                    //     initialChildSize: 0.4,
                    //     listType: MultiSelectListType.CHIP,
                    //     searchable: true,
                    //     buttonText: const Text('Tags'),
                    //     title: const Text('Tags'),
                    //     items: controller.tags
                    //             ?.map((e) =>
                    //                 MultiSelectItem<int>(e.id!, e.title!))
                    //             .toList() ??
                    //         [],
                    //     initialValue: _selectedTags,
                    //     onConfirm: (values) => _selectedTags = values.cast(),
                    //     chipDisplay: MultiSelectChipDisplay(
                    //       onTap: (value) =>
                    //           setState(() => _selectedTags.remove(value)),
                    //     ),
                    //   );
                    // }),
                    const SizedBox(height: 10),
                    WidgetTextField(
                      controller: _contentController,
                      labelText: 'Content',
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
                            controller: _createNoteBtnController,
                            onPressed: () => _createNote(),
                            child: const Text('Add',
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

  void _createNote() async {
    await _noteListController.createNote(NoteModel(
      title: _titleController.text,
      content: _contentController.text,
    ));

    _createNoteBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _createNoteBtnController.reset();
    Get.back();
  }

  Future<dynamic> showDeleteNoteDialog(BuildContext context, int noteId) {
    return showDialog(
      context: context,
      builder: (_) => WidgetDialogOverlay(
        title: "Delete Note",
        body: Column(
          children: [
            const Text(
              "Are you sure you want to delete this note?",
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
                    controller: _deleteNoteBtnController,
                    color: Colors.red,
                    onPressed: () => _deleteNote(noteId),
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

  void _deleteNote(int noteId) async {
    await _noteListController.deleteNote(noteId);

    _deleteNoteBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _deleteNoteBtnController.reset();
    Get.back();
  }
}
