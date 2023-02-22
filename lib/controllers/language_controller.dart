import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/spref_key.dart';
import 'package:npssolutions_mobile/services/spref.dart';

class LanguageValue {
  final Locale locale;
  final String icon;

  LanguageValue({required this.locale, required this.icon});
}

class LanguageController extends GetxController {
  final Map<String, LanguageValue> languages = {
    'en': LanguageValue(
        locale: const Locale('en'), icon: 'icons/flags/png/gb.png'),
    'vi': LanguageValue(
        locale: const Locale('vi'), icon: 'icons/flags/png/vn.png'),
  };

  LanguageValue? currentLocale;

  LanguageController() {
    currentLocale =
        languages[SPref.instance.get(SPrefKey.languageCode) ?? 'en'];
  }

  Future setCurrentLocale(String languageCode) async {
    if (!languages.containsKey(languageCode)) return;

    currentLocale = languages[languageCode];
    await Get.updateLocale(Locale(languageCode));
    await SPref.instance.set(SPrefKey.languageCode, languageCode);

    update();
  }
}
