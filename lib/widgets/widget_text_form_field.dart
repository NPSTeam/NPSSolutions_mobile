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
        hintText: hintText,
      ),
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: (value) => onChanged,
      onEditingComplete: onEditingComplete,
    );
  }
}
