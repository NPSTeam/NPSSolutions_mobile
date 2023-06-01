import 'package:async/async.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/controllers/card_detail_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../configs/string_const.dart';
import '../../../configs/themes/assets_const.dart';
import '../../../configs/themes/color_const.dart';
import '../../../helpers/util_function.dart';
import '../../../helpers/utils.dart';
import '../../../widgets/widget_date_time_field.dart';
import '../../../widgets/widget_dialog_overlay.dart';
import '../../../widgets/widget_text_field.dart';
import '../../../widgets/widget_text_form_field.dart';

class CardDetailPage extends StatefulWidget {
  const CardDetailPage({
    super.key,
    required this.boardId,
    required this.cardId,
    required this.workspaceId,
  });

  final int boardId;
  final int cardId;
  final int workspaceId;

  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  final CardDetailController _cardDetailController =
      Get.put(CardDetailController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;

  final _cardDetailFormKey = GlobalKey<FormState>();

  late RestartableTimer _saveCardTimer;

  bool isLoading = true;

  @override
  void initState() {
    _loadData();

    _saveCardTimer =
        RestartableTimer(const Duration(milliseconds: 500), () => saveCard());

    super.initState();
  }

  void _loadData() async {
    await EasyLoading.show();

    await _cardDetailController.getCard(
        boardId: widget.boardId, cardId: widget.cardId);
    await _cardDetailController.getWorkspaceUsers(widget.workspaceId);

    if (_cardDetailController.workspaceUsers != null) {
      for (var e in _cardDetailController.workspaceUsers!) {
        e.checked = _cardDetailController.card?.memberIds
            ?.any((element) => element == e.userId);
      }
    }

    setState(() {
      _titleController.text = _cardDetailController.card?.title ?? '';
      _descriptionController.text =
          _cardDetailController.card?.description ?? '';
      _dueDate = _cardDetailController.card?.dueDate;

      isLoading = false;
    });

    await EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.focusScope?.unfocus(),
      child: GetBuilder<CardDetailController>(builder: (cardDetailController) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConst.primary,
            centerTitle: true,
            title: const Text('Card'),
          ),
          body: isLoading
              ? const SizedBox()
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Form(
                          key: _cardDetailFormKey,
                          child: Column(
                            children: [
                              WidgetTextFormField(
                                controller: _titleController,
                                labelText: 'Title',
                                hintText: 'Title',
                                validator: (value) => value?.isEmpty == true
                                    ? 'Title cannot be blank'
                                    : null,
                                onChanged: (value) => _saveCardTimer.reset(),
                                // onEditingComplete: () => _saveCardTimer.reset(),
                              ),
                              const SizedBox(height: 10),
                              WidgetDateTimeField(
                                controller: TextEditingController(
                                    text: UtilFunction.dateTimeToString(
                                        _dueDate)),
                                initialValue: _dueDate,
                                labelText: 'Due Date',
                                format: DateFormat('dd/MM/yyyy – HH:mm'),
                                onShowPicker: (context, currentValue) async {
                                  DateTime? dateTime = await showDatePicker(
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
                                      return null;
                                    }
                                  });

                                  if (dateTime != null) {
                                    _dueDate = dateTime;
                                    _saveCardTimer.reset();
                                  }

                                  return _dueDate;
                                },
                              ),
                              const SizedBox(height: 10),
                              WidgetTextField(
                                controller: _descriptionController,
                                labelText: 'Description',
                                hintText: 'Write something...',
                                onChanged: (value) => _saveCardTimer.reset(),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Ionicons.chatbox_ellipses_outline),
                                  const SizedBox(width: 5),
                                  Text('Comments'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 19.0,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: Image.asset(AssetsConst
                                            .profileAvatarPlaceholder)
                                        .image,
                                    foregroundImage: NetworkImage(
                                        Get.find<AuthController>()
                                                .auth
                                                ?.currentUser
                                                ?.photoURL ??
                                            StringConst.placeholderImageUrl),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: WidgetTextField(
                                      controller: _descriptionController,
                                      labelText: 'Comment',
                                      hintText: 'Add comment',
                                      onChanged: (value) =>
                                          _saveCardTimer.reset(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              // setState(() {
                              //   isAddingTask = true;
                              // });
                              await showCheckedUsersDialog(context);
                            },
                            child: const Icon(Icons.account_circle_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }

  Future saveCard() async {
    if (_cardDetailFormKey.currentState?.validate() == false) {
      return;
    }

    if (_cardDetailController.card != null) {
      _cardDetailController.card!.title = _titleController.text.trim();
      _cardDetailController.card!.dueDate = _dueDate;
      _cardDetailController.card!.description =
          _descriptionController.text.trim();
      _cardDetailController.card!.memberIds = _cardDetailController
          .workspaceUsers
          ?.where((element) => element.checked == true)
          .map((e) => e.userId!)
          .toList();

      _cardDetailController.updateCard(
        boardId: widget.boardId,
        cardId: widget.cardId,
        card: _cardDetailController.card!,
      );
    }
  }

  Future<dynamic> showCheckedUsersDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return GetBuilder<CardDetailController>(builder: (controller) {
                return WidgetDialogOverlay(
                  title: "Users",
                  body: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Get.width * 0.85,
                      maxHeight: Get.height * 0.4,
                    ),
                    child: (controller.workspaceUsers?.isEmpty ?? false)
                        ? const Text(
                            "Nothing here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                          )
                        : LiveList(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            physics: const BouncingScrollPhysics(),
                            showItemInterval: const Duration(milliseconds: 20),
                            showItemDuration: const Duration(milliseconds: 200),
                            itemCount: controller.workspaceUsers?.length ?? 0,
                            itemBuilder: animationItemBuilder(
                              (index) => workspaceCheckedUserListItem(
                                  controller, index, setState),
                            ),
                          ),
                  ),
                );
              });
            }));
  }

  Card workspaceCheckedUserListItem(
    CardDetailController controller,
    int index,
    void Function(void Function()) setState,
  ) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior: Clip.hardEdge,
      child: CheckboxListTile(
        value: controller.workspaceUsers?[index].checked ?? false,
        onChanged: (value) => {
          setState(() {
            controller.workspaceUsers?[index].checked = value;

            _saveCardTimer.reset();
          })
        },
        secondary: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
              Image.asset(AssetsConst.profileAvatarPlaceholder).image,
          foregroundImage:
              NetworkImage(controller.workspaceUsers?[index].avatar ?? ''),
        ),
        title: Text(
          controller.workspaceUsers?[index].username ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.workspaceUsers?[index].email ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              controller.workspaceUsers![index].birthDay != null
                  ? DateFormat("dd/MM/yyyy")
                      .format(controller.workspaceUsers![index].birthDay!)
                  : '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              controller.workspaceUsers?[index].phoneNumber ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
