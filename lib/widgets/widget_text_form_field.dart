import 'package:flutter/material.dart';

class WidgetTextFormField extends StatelessWidget {
  const WidgetTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.autovalidateMode,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[500]),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: (value) => onChanged,
      onEditingComplete: onEditingComplete,
    );
  }
}
