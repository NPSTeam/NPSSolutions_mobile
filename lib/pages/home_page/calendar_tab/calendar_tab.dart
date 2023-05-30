import 'package:calendar_view/calendar_view.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:npssolutions_mobile/controllers/calendar_controller.dart';
import 'package:npssolutions_mobile/pages/home_page/calendar_tab/calendar_detail_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../configs/themes/color_const.dart';
import '../../../helpers/util_function.dart';
import '../../../models/event_extended_pros_model.dart';
import '../../../models/event_model.dart';
import '../../../widgets/widget_date_time_field.dart';
import '../../../widgets/widget_dialog_overlay.dart';
import '../../../widgets/widget_text_field.dart';
import '../../../widgets/widget_text_form_field.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  final CalendarController _calendarController = Get.put(CalendarController());
  final _eventController = EventController();

  final RoundedLoadingButtonController _createNoteBtnController =
      RoundedLoadingButtonController();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  int? _selectedLabel;

  final _createEventFormKey = GlobalKey<FormState>();

  _loadData() async {
    await EasyLoading.show();

    await _calendarController.getEventList();
    await _calendarController.getLabels();

    _eventController.removeWhere((element) => true);
    for (var e in _calendarController.events) {
      _eventController.add(CalendarEventData(
        date: e.start ?? DateTime.now(),
        title: e.title ?? '',
        event: e.id,
      ));
    }

    await EasyLoading.dismiss();
  }

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadData();

    return Scaffold(
      backgroundColor: ColorConst.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25.0),
                  const SizedBox(height: 25.0),
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
                  padding: const EdgeInsets.only(top: 20.0),
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
                          child: MonthView(
                            controller: _eventController,
                            borderSize: 0.5,
                            minMonth: DateTime(1900),
                            maxMonth: DateTime(2100),
                            onCellTap: (event, date) =>
                                showCreateEventDialog(context),
                            onEventTap: (event, date) => Get.to(
                                () => CalendarDetailPage(
                                    eventId: event.event as int),
                                transition: Transition.cupertino),
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
  }

  Future<dynamic> showCreateEventDialog(BuildContext context) {
    _titleController.clear();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 1));
    _descriptionController.clear();

    return showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return WidgetDialogOverlay(
            title: "Add Event",
            body: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height * 0.4),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _createEventFormKey,
                  child: Column(
                    children: [
                      WidgetTextFormField(
                        controller: _titleController,
                        labelText: 'Title *',
                        validator: (value) => value?.isEmpty == true
                            ? 'Title cannot be blank'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      WidgetDateTimeField(
                        controller: TextEditingController(
                            text: UtilFunction.dateTimeToString(_startDate)),
                        initialValue: _startDate,
                        format: DateFormat('dd/MM/yyyy – HH:mm'),
                        labelText: 'Start',
                        onShowPicker: (context, currentValue) async {
                          _startDate = await showDatePicker(
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

                          return _startDate;
                        },
                      ),
                      const SizedBox(height: 10),
                      WidgetDateTimeField(
                        controller: TextEditingController(
                            text: UtilFunction.dateTimeToString(_endDate)),
                        initialValue: _endDate,
                        format: DateFormat('dd/MM/yyyy – HH:mm'),
                        labelText: 'End',
                        onShowPicker: (context, currentValue) async {
                          _endDate = await showDatePicker(
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

                          return _endDate;
                        },
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
                              value: _selectedLabel,
                              hint: Text(
                                'Select Label',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: _calendarController.labels
                                  .map((item) => DropdownMenuItem(
                                        value: item.id,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    HexColor(item.color ?? ''),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              item.title ?? '',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() => _selectedLabel = value);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      WidgetTextFormField(
                        controller: _descriptionController,
                        labelText: 'Description *',
                        minLines: 5,
                        maxLines: 10,
                        validator: (value) => value?.isEmpty == true
                            ? 'Description cannot be blank'
                            : null,
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
                              onPressed: () => _createEvent(),
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
            ),
          );
        },
      ),
    );
  }

  void _createEvent() async {
    if (_createEventFormKey.currentState?.validate() != true) {
      _createNoteBtnController.error();
      await Future.delayed(const Duration(seconds: 1));
      _createNoteBtnController.reset();
      return;
    }
    if (await _calendarController.createEvent(EventModel(
      title: _titleController.text,
      start: DateTime.now(),
      end: DateTime.now(),
      extendedProps: EventExtendedProsModel(
          desc: _descriptionController.text, label: _selectedLabel),
    ))) {
      _createNoteBtnController.success();
      await Future.delayed(const Duration(seconds: 1));
      _createNoteBtnController.reset();
      Get.back();
      setState(() {});
    } else {
      _createNoteBtnController.error();
      await Future.delayed(const Duration(seconds: 1));
      _createNoteBtnController.reset();
    }
  }
}
