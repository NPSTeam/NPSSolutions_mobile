import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class WidgetDropdown extends StatelessWidget {
  const WidgetDropdown({
    super.key,
    this.hintText,
    this.excludeSelected = false,
    required this.items,
    required this.controller,
    this.listItemBuilder,
    this.onChanged,
  });

  final String? hintText;
  final bool excludeSelected;
  final List<String>? items;
  final TextEditingController controller;
  final Widget Function(BuildContext, String)? listItemBuilder;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      hintText: hintText,
      excludeSelected: excludeSelected,
      borderSide: const BorderSide(color: Colors.grey),
      items: items,
      controller: controller,
      listItemBuilder: listItemBuilder,
      onChanged: onChanged,
    );
  }
}
