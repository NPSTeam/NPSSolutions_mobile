import 'package:flutter/material.dart';

class WidgetTextField extends StatelessWidget {
  const WidgetTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.minLines,
    this.maxLines,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[500]),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        // floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }
}
