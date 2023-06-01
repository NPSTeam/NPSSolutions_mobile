import 'package:async/async.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/configs/themes/text_style_const.dart';
import 'package:npssolutions_mobile/models/board_card_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/scrumboard_board_controller.dart';
import '../../../models/board_list_model.dart';
import '../../../models/board_model.dart';
import '../../../models/scrumboard_model.dart';
import '../../../widgets/widget_dialog_overlay.dart';
import '../../../widgets/widget_text_form_field.dart';
import 'card_detail_page.dart';

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
  final RoundedLoadingButtonController _createListBtnController =
      RoundedLoadingButtonController();

  final _createCardFormKey = GlobalKey<FormState>();
  final _createListFormKey = GlobalKey<FormState>();
  final _renameListFormKey = GlobalKey<FormState>();

  bool isLoading = true;

  Future _loadData() async {
    await EasyLoading.show();

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
                contentsWhenEmpty: const SizedBox(),
                header: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, top: 10, bottom: 10, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        boardList.title ?? '',
                        overflow: TextOverflow.ellipsis,
                      )),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: Text(
                              '${_scrumboardBoardController.boardCards?.where((e) => e.listId == boardList.id).length ?? 0}',
                              style: TextStyleConst.regularStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 20,
                        child: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Ionicons.ellipsis_vertical_outline),
                          iconSize: 20,
                          onSelected: (value) {
                            switch (value) {
                              case 'REMOVE_LIST':
                                EasyLoading.show();
                                _scrumboardBoardController
                                    .removeBoardList(
                                        boardId: widget.scrumboardId,
                                        listId: boardList.id!)
                                    .then((value) {
                                  EasyLoading.dismiss();
                                  if (value) {
                                    _loadData();
                                  }
                                });
                                break;
                              case 'RENAME_LIST':
                                showRenameBoardListDialog(context,
                                    boardId: widget.scrumboardId,
                                    listId: boardList.id!);
                                break;
                            }
                          },
                          itemBuilder: (_) {
                            return [
                              PopupMenuItem(
                                value: 'RENAME_LIST',
                                child: Row(
                                  children: const [
                                    Icon(Ionicons.create_outline,
                                        color: Colors.black),
                                    SizedBox(width: 10),
                                    Text('Rename'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'REMOVE_LIST',
                                child: Row(
                                  children: const [
                                    Icon(Ionicons.trash_outline,
                                        color: Colors.black),
                                    SizedBox(width: 10),
                                    Text('Remove'),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                leftSide: const SizedBox(width: 10),
                rightSide: const SizedBox(width: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset: const Offset(0, 0.5),
                    ),
                  ],
                ),
                children: _scrumboardBoardController.boardCards
                        ?.where((e) => e.listId == boardList.id)
                        .map((boardCard) => DragAndDropItem(
                              child: Center(
                                child: Card(
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => CardDetailPage(
                                          boardId: widget.scrumboardId,
                                          cardId: boardCard.id!,
                                          workspaceId:
                                              _scrumboardBoardController
                                                  .scrumboard!.workspaceId!,
                                        ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            boardCard.title ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: const [
                                              Icon(Ionicons.eye_outline,
                                                  size: 15),
                                              Icon(Ionicons.attach_outline,
                                                  size: 15),
                                              Text('0'),
                                            ],
                                          ),
                                        ],
                                      ),
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
                        Icon(Ionicons.add_circle_outline,
                            size: 15, color: Colors.grey),
                        SizedBox(width: 5),
                        Text('Add another card',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList() ??
        [];

    setState(() => isLoading = false);

    await EasyLoading.dismiss();
  }

  @override
  void initState() {
    _loadData();

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showCreateBoardListDialog(context, boardId: widget.scrumboardId);
          },
          child: const Icon(Ionicons.add_outline),
        ),
        body: isLoading
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: DragAndDropLists(
                  axis: Axis.horizontal,
                  onItemReorder: _onItemReorder,
                  onListReorder: _onListReorder,
                  listWidth: 200,
                  listPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  onItemDraggingChanged: (item, isDragging) {
                    HapticFeedback.lightImpact();
                  },
                  listDragOnLongPress: false,
                  lastItemTargetHeight: 8,
                  addLastItemTargetHeightToTop: true,
                  lastListTargetSize: 40,
                  children: _getContent(),
                ),
              ),
      );
    });
  }

  _getContent() => _contents;

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

  Future<dynamic> showCreateBoardListDialog(BuildContext context,
      {required int boardId}) {
    final TextEditingController listTitleController = TextEditingController();

    return showDialog(
      context: context,
      builder: (_) => WidgetDialogOverlay(
        title: 'Add Board List',
        body: Column(
          children: [
            Form(
              key: _createListFormKey,
              child: WidgetTextFormField(
                controller: listTitleController,
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
                    controller: _createListBtnController,
                    color: ColorConst.primary,
                    onPressed: () => _createBoardList(
                      title: listTitleController.text.trim(),
                      boardId: boardId,
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

  Future<dynamic> showRenameBoardListDialog(BuildContext context,
      {required int boardId, required int listId}) {
    final TextEditingController listTitleController = TextEditingController();

    return showDialog(
      context: context,
      builder: (_) => WidgetDialogOverlay(
        title: 'Rename Board List',
        body: Column(
          children: [
            Form(
              key: _renameListFormKey,
              child: WidgetTextFormField(
                controller: listTitleController,
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
                    controller: _createListBtnController,
                    color: ColorConst.primary,
                    onPressed: () => _renameBoardList(
                      title: listTitleController.text.trim(),
                      boardId: boardId,
                      listId: listId,
                    ),
                    child: const Text('Rename',
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
      card: BoardCardModel(title: title, listId: listId, boardId: boardId),
    );

    _createCardBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _createCardBtnController.reset();
    Get.back();

    await _loadData();
  }

  _createBoardList({
    required String title,
    required int boardId,
  }) async {
    if (title.trim().isEmpty) {
      _createListBtnController.reset();
      _createListFormKey.currentState?.validate();
      return;
    }

    await _scrumboardBoardController.createList(
      boardId: boardId,
      list: BoardListModel(title: title, boardId: boardId),
    );

    _createListBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _createListBtnController.reset();
    Get.back();

    await _loadData();
  }

  _renameBoardList({
    required String title,
    required int boardId,
    required int listId,
  }) async {
    if (title.trim().isEmpty) {
      _createListBtnController.reset();
      _renameListFormKey.currentState?.validate();
      return;
    }

    await _scrumboardBoardController.renameBoardList(
      boardId: boardId,
      listId: listId,
      list: BoardListModel(id: listId, title: title, boardId: boardId),
    );

    _createListBtnController.success();
    await Future.delayed(const Duration(seconds: 1));
    _createListBtnController.reset();
    Get.back();

    await _loadData();
  }
}
