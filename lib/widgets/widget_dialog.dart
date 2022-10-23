import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/utils/constants.dart';

class WidgetDialog {
  static showDialog({
    required String title,
    Widget? content,
    String? middleText,
    String? cancelText,
    String? confirmText,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      content: content,
      middleText: middleText ?? "Middle Text",
      cancel: cancelText != null
          ? TextButton(
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: kSecondaryColor,
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(100)),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(color: kSecondaryColor),
              ),
              onPressed: () {
                onCancel?.call();
                Get.back();
              },
            )
          : null,
      confirm: confirmText != null
          ? TextButton(
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: kSecondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
              ),
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onConfirm?.call();
                Get.back();
              },
            )
          : null,
    );
  }
}
