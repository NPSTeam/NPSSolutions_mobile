import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetLoadingDialog {
  static showDialog({
    String? title,
  }) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 15),
              Text(title ?? 'Loading...')
            ],
          ),
        ),
      ),
    );
  }
}
