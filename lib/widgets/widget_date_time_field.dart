import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WidgetDateTimeField extends StatelessWidget {
  const WidgetDateTimeField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.format,
    required this.onShowPicker,
  });

  final TextEditingController? controller;
  final DateTime? initialValue;
  final String? labelText;
  final DateFormat? format;
  final Future<DateTime?> Function(BuildContext, DateTime?) onShowPicker;

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: controller,
      format: format ?? DateFormat("yyyy-MM-dd HH:mm"),
      initialValue: initialValue,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: labelText,
      ),
      onShowPicker: onShowPicker,
    );
  }
}
