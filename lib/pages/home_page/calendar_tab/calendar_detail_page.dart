import 'package:async/async.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/controllers/calendar_controller.dart';

import '../../../configs/themes/color_const.dart';
import '../../../helpers/util_function.dart';
import '../../../models/event_model.dart';
import '../../../widgets/widget_date_time_field.dart';
import '../../../widgets/widget_text_form_field.dart';

class CalendarDetailPage extends StatefulWidget {
  const CalendarDetailPage({super.key, required this.eventId});

  final int eventId;

  @override
  State<CalendarDetailPage> createState() => _CalendarDetailPageState();
}

class _CalendarDetailPageState extends State<CalendarDetailPage> {
  EventModel? _eventModel;

  final _taskDetailFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final CalendarController _calendarController = Get.find<CalendarController>();

  late RestartableTimer _saveTaskTimer;

  loadData() async {
    await EasyLoading.show(status: 'Loading...');

    _saveTaskTimer =
        RestartableTimer(const Duration(milliseconds: 500), () => saveTask());

    _eventModel = await _calendarController.getEvent(widget.eventId);

    if (_eventModel?.title != null) {
      _titleController.text = _eventModel!.title!;
    }

    if (_eventModel?.extendedProps?.desc != null) {
      _descriptionController.text = _eventModel!.extendedProps!.desc!;
    }

    setState(() {});
    await EasyLoading.dismiss();
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarController>(builder: (calendarController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.primary,
          centerTitle: true,
          title: const Text("Calendar"),
          actions: _eventModel == null
              ? []
              : [
                  PopupMenuButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onSelected: (value) async {
                      if (value == 'DELETE') {
                        await EasyLoading.show(status: 'Deleting...');
                        await calendarController.deleteEvent(_eventModel!.id!);
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
        body: _eventModel == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _taskDetailFormKey,
                    child: Column(
                      children: [
                        WidgetTextFormField(
                          controller: _titleController,
                          labelText: 'Title',
                          hintText: 'Title',
                          validator: (value) => value?.isEmpty == true
                              ? 'Title cannot be blank'
                              : null,
                          onChanged: (value) => _saveTaskTimer.reset(),
                          onEditingComplete: () => _saveTaskTimer.reset(),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 70,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    gapPadding: 0)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                // isExpanded: true,
                                value: _eventModel!.extendedProps?.label,
                                hint: Text(
                                  'Select Label',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: calendarController.labels
                                    .map((item) => DropdownMenuItem(
                                          value: item.id,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: HexColor(
                                                      item.color ?? ''),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                item.title ?? '',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _eventModel!
                                      .extendedProps?.label = value);
                                  _saveTaskTimer.reset();
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        WidgetDateTimeField(
                          controller: TextEditingController(
                              text: UtilFunction.dateTimeToString(
                                  _eventModel!.start)),
                          initialValue: _eventModel!.start,
                          format: DateFormat('dd/MM/yyyy – HH:mm'),
                          labelText: 'Start',
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
                              _eventModel!.start = dateTime;
                              _saveTaskTimer.reset();
                            }

                            return dateTime;
                          },
                        ),
                        const SizedBox(height: 10),
                        WidgetDateTimeField(
                          controller: TextEditingController(
                              text: UtilFunction.dateTimeToString(
                                  _eventModel!.end)),
                          initialValue: _eventModel!.end,
                          format: DateFormat('dd/MM/yyyy – HH:mm'),
                          labelText: 'End',
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
                              _eventModel!.end = dateTime;
                              _saveTaskTimer.reset();
                            }

                            return dateTime;
                          },
                        ),
                        const SizedBox(height: 10),
                        WidgetTextFormField(
                          controller: _descriptionController,
                          labelText: 'Description *',
                          minLines: 5,
                          maxLines: 10,
                          onChanged: (value) => _saveTaskTimer.reset(),
                          validator: (value) => value?.isEmpty == true
                              ? 'Description cannot be blank'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }

  Future saveTask() async {
    if (_taskDetailFormKey.currentState?.validate() == false) {
      return;
    }

    if (_eventModel != null) {
      _eventModel!.title = _titleController.text.trim();
      _eventModel!.extendedProps?.desc = _descriptionController.text.trim();

      await _calendarController.updateEvent(_eventModel!);
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
