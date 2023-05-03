import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/scrumboard_board_controller.dart';
import '../../../models/scrumboard_model.dart';

class ScrumboardBoardPage extends StatefulWidget {
  const ScrumboardBoardPage({super.key, required this.scrumboardId});

  final int scrumboardId;

  @override
  State<ScrumboardBoardPage> createState() => _ScrumboardBoardPageState();
}

class _ScrumboardBoardPageState extends State<ScrumboardBoardPage> {
  final ScrumboardBoardController _scrumboardBoardController =
      Get.put(ScrumboardBoardController());

  List<DragAndDropList> _contents = [];

  Future loadData() async {
    await _scrumboardBoardController.getScrumboard(widget.scrumboardId);
    await _scrumboardBoardController.getBoardLists(widget.scrumboardId);
    await _scrumboardBoardController.getBoardCards(widget.scrumboardId);

    _contents = _scrumboardBoardController.boardLists
            ?.map((boardList) => DragAndDropList(
                header: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(boardList.title ?? ''),
                    ],
                  ),
                ),
                leftSide: const SizedBox(width: 10),
                rightSide: const SizedBox(width: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.1),
                ),
                children: _scrumboardBoardController.boardCards
                        ?.where((e) => e.listId == boardList.id)
                        .map((boardCard) => DragAndDropItem(
                              child: Center(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(boardCard.title ?? ''),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList() ??
                    []))
            .toList() ??
        [];
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScrumboardBoardController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.primary,
          centerTitle: true,
          title: Text(controller.scrumboard?.title ?? "Scrumboard"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: DragAndDropLists(
            children: _contents,
            axis: Axis.horizontal,
            onItemReorder: _onItemReorder,
            onListReorder: (_, __) {},
            listWidth: 150,
            listPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            onItemDraggingChanged: (item, isDragging) {
              HapticFeedback.lightImpact();
            },
            listDragOnLongPress: false,
            lastItemTargetHeight: 8,
            addLastItemTargetHeightToTop: true,
            lastListTargetSize: 40,
          ),
        ),
      );
    });
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    // setState(() {
    //   var movedTaskItem =
    //       _contents[oldListIndex].children.removeAt(oldItemIndex);
    //   _contents[newListIndex].children.insert(newItemIndex, movedTaskItem);

    //   var movedTask = _taskListController.tasks?.removeAt(oldItemIndex);
    //   if (movedTask != null) {
    //     _taskListController.tasks?.insert(newItemIndex, movedTask);
    //     _taskListController.tasks
    //         ?.asMap()
    //         .forEach((index, value) => value.order = index);
    //   }
    // });

    // _updateTaskOrderTimer.reset();
  }
}
