import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/controllers/language_controller.dart';

class WidgetLanguageToggle extends StatelessWidget {
  const WidgetLanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (controller) {
      return AnimatedToggleSwitch.dual(
        current: controller.currentLocale?.locale.languageCode,
        first: 'en',
        second: 'vi',
        dif: 5,
        borderColor: Colors.transparent,
        borderWidth: 3,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1.5),
          ),
        ],
        indicatorColor: Colors.transparent,
        indicatorSize: const Size(30, 30),
        height: 36,
        iconBuilder: (value) =>
            controller.currentLocale?.locale.languageCode == 'en'
                ? Image.asset('assets/icons/png/flag_uk_rounded.png')
                : Image.asset('assets/icons/png/flag_vietnam_rounded.png'),
        textBuilder: (value) => value == 'en'
            ? const Center(child: Text('EN'))
            : const Center(child: Text('VI')),
        onChanged: (value) async {
          // await Future.delayed(const Duration(milliseconds: 500));
          await controller.setCurrentLocale(value ?? 'vi');
        },
      );
    });
  }
}
