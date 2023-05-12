import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class WidgetMultiSelectBottomSheetField extends StatelessWidget {
  const WidgetMultiSelectBottomSheetField({
    super.key,
    this.buttonText,
    this.title,
    required this.items,
    this.initialValue = const [],
    required this.onConfirm,
    this.chipDisplay,
  });

  final String? buttonText;
  final Widget? title;
  final List<MultiSelectItem<Object?>> items;
  final List<Object?> initialValue;
  final Function(List<Object?>) onConfirm;
  final MultiSelectChipDisplay<Object?>? chipDisplay;

  @override
  Widget build(BuildContext context) {
    return MultiSelectBottomSheetField(
      buttonIcon: const Icon(Ionicons.chevron_down_outline),
      initialChildSize: 0.4,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      listType: MultiSelectListType.CHIP,
      searchable: true,
      buttonText: buttonText != null ? Text(buttonText!) : null,
      title: title,
      items: items,
      initialValue: initialValue,
      onConfirm: onConfirm,
      chipDisplay: chipDisplay,
    );
  }
}
