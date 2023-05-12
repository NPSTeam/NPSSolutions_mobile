import 'package:async/async.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/models/board_card_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/scrumboard_board_controller.dart';
import '../../../models/board_model.dart';
import '../../../models/scrumboard_model.dart';
import '../../../widgets/widget_dialog_overlay.dart';
import '../../../widgets/widget_text_form_field.dart';

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

  late RestartableTimer _updateBoardOrderTimer;

  final RoundedLoadingButtonController _createCardBtnController =
      RoundedLoadingButtonController();

  final _createCardFormKey = GlobalKey<FormState>();

  Future loadData() async {
    EasyLoading.show();

    await _scrumboardBoardController.getScrumboard(widget.scrumboardId);
    await _scrumboardBoardController.getBoardLists(widget.scrumboardId);
    await _scrumboardBoardController.getBoardCards(widget.scrumboardId);
    _scrumboardBoardController.scrumboard?.lists = _scrumboardBoardController
        .boardLists
        ?.map((e) => BoardModel(
            id: e.id,
            order: e.order,
            cards: _scrumboardBoardController.boardCards
                ?.where((card) => card.listId == e.id)
                .map((e) => e.id!)
                .toList()))
        .toList();

    _contents = _scrumboardBoardController.boardLists
            ?.map(
              (boardList) => DragAndDropList(
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
                    [],
                footer: InkWell(
                  onTap: () {
                    showCreateCardDialog(context,
                        boardId: widget.scrumboardId, listId: boardList.id!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Ionicons.add_circle_outline, size: 15),
                        SizedBox(width: 5),
                        Text('Add another card',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList() ??
        [];

    await EasyLoading.dismiss();
  }

  @override
  void initState() {
    loadData();

    _updateBoardOrderTimer = RestartableTimer(const Duration(seconds: 1),
        () => _scrumboardBoardController.updateBoard());
    _updateBoardOrderTimer.cancel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScrumboardBoardController>(
        builder: (scrumboardBoardController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.primary,
          centerTitle: true,
          title:
              Text(scrumboardBoardController.scrumboard?.title ?? "Scrumboard"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: DragAndDropLists(
            children: _contents,
            axis: Axis.horizontal,
            onItemReorder: _onItemReorder,
            onListReorder: _onListReorder,
            listWidth: 175,
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

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedListItem = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedListItem);

      var movedList =
          _scrumboardBoardController.boardLists?.removeAt(oldListIndex);
      if (movedList != null) {
        _scrumboardBoardController.boardLists?.insert(newListIndex, movedList);
        _scrumboardBoardController.boardLists
            ?.asMap()
            .forEach((index, value) => value.order = index);
      }
    });

    _updateBoardOrderTimer.reset();
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedCardItem =
          _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedCardItem);
    });

    var movedCard = _scrumboardBoardController
        .scrumboard?.lists?[oldListIndex].cards
        ?.removeAt(oldItemIndex);

    _scrumboardBoardController.scrumboard?.lists?[newListIndex].cards
        ?.insert(newItemIndex, movedCard!);

    _updateBoardOrderTimer.reset();
  }

  Future<dynamic> showCreateCardDialog(
    BuildContext context, {
    required int boardId,
    required int listId,
  }) {
    final TextEditingController cardTitleController = TextEditingController();

    return showDialog(
      context: context,
      builder: (_) => WidgetDialogOverlay(
        title: 'Add Card',
        body: Column(
          children: [
            Form(
              key: _createCardFormKey,
              child: WidgetTextFormField(
                controller: cardTitleController,
                labelText: 'Title',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value?.isEmpty == true ? 'Title cannot be blank' : null,
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
                    controller: _createCardBtnController,
                    color: ColorConst.primary,
                    onPressed: () => _createCard(
                      title: cardTitleController.text.trim(),
                      boardId: boardId,
                      listId: listId,
                    ),
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

  _createCard({
    required String title,
    required int boardId,
    required int listId,
  }) async {
    if (title.trim().isEmpty) {
      _createCardBtnController.reset();
      _createCardFormKey.currentState?.validate();
      return;
    }

    await _scrumboardBoardController.createCard(
      boardId: boardId,
      card: BoardCardModel(title: title, listId: listId),
    );

    _createCardBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _createCardBtnController.reset();
    Get.back();
  }
}
