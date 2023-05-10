import 'package:flutter/material.dart';

class WidgetTextField extends StatelessWidget {
  const WidgetTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
