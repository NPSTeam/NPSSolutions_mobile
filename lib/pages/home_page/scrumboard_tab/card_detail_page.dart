import 'package:async/async.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/controllers/card_detail_controller.dart';

import '../../../configs/themes/color_const.dart';
import '../../../helpers/util_function.dart';
import '../../../widgets/widget_date_time_field.dart';
import '../../../widgets/widget_text_field.dart';
import '../../../widgets/widget_text_form_field.dart';

class CardDetailPage extends StatefulWidget {
  const CardDetailPage({
    super.key,
    required this.boardId,
    required this.cardId,
  });

  final int boardId;
  final int cardId;

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

  @override
  void initState() {
    _loadData();

    _saveCardTimer =
        RestartableTimer(const Duration(milliseconds: 500), () => saveCard());

    super.initState();
  }

  void _loadData() async {
    EasyLoading.show();

    await _cardDetailController.getCard(
        boardId: widget.boardId, cardId: widget.cardId);

    setState(() {
      _titleController.text = _cardDetailController.card?.title ?? '';
      _descriptionController.text =
          _cardDetailController.card?.description ?? '';
      _dueDate = _cardDetailController.card?.dueDate;
    });

    EasyLoading.dismiss();
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
            title: Text(cardDetailController.card?.title ?? ''),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _cardDetailFormKey,
              child: Column(
                children: [
                  WidgetTextFormField(
                    controller: _titleController,
                    labelText: 'Title',
                    hintText: 'Title',
                    validator: (value) =>
                        value?.isEmpty == true ? 'Title cannot be blank' : null,
                    onChanged: (value) => _saveCardTimer.reset(),
                    onEditingComplete: () => _saveCardTimer.reset(),
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

                      _saveCardTimer.reset();
                      return _dueDate;
                    },
                  ),
                  const SizedBox(height: 10),
                  WidgetTextField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    hintText: 'Write something...',
                    minLines: 5,
                    onChanged: (value) => _saveCardTimer.reset(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future saveCard() async {
    if (_cardDetailFormKey.currentState?.validate() == false) {
      return;
    }

    if (_cardDetailController.card != null) {}

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
