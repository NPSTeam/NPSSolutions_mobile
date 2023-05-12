import 'package:flutter/material.dart';

import '../configs/themes/color_const.dart';

class WidgetCheckboxListTile extends StatelessWidget {
  const WidgetCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
  });

  final bool? value;
  final Function(bool?)? onChanged;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      checkboxShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      activeColor: ColorConst.primary,
      contentPadding: const EdgeInsets.all(0),
      title: title,
      value: value,
      onChanged: onChanged,
    );
  }
}
