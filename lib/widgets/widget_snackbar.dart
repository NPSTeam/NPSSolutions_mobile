import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetSnackbar {
  static showSnackbar({
    required String title,
    required String message,
    Icon? icon,
    Duration? duration,
    EdgeInsets? margin,
    bool? showProgressIndicator,
    bool? shouldIconPulse,
  }) {
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 2),
      margin:
          margin ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      icon: icon,
      showProgressIndicator: showProgressIndicator,
      shouldIconPulse: shouldIconPulse,
    );
  }
}
