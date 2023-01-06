import 'package:flutter/material.dart';

class LanguageValue {
  final Locale locale;
  final String icon;

  LanguageValue({required this.locale, required this.icon});
}

class LanguageController extends ChangeNotifier {
  final Map<String, LanguageValue> languages = {
    'en': LanguageValue(
        locale: const Locale('en'), icon: 'icons/flags/png/gb.png'),
    'vi': LanguageValue(
        locale: const Locale('vi'), icon: 'icons/flags/png/vn.png'),
  };

  LanguageValue? currentLocale;

  LanguageController() {
    currentLocale = languages['en'];
  }

  setCurrentLocale(String locale) {
    if (!languages.containsKey(locale)) return;

    currentLocale = languages[locale];
    notifyListeners();
  }
}
