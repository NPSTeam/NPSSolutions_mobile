import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:npssolutions_mobile/controllers/language_controller.dart';
import 'package:npssolutions_mobile/generated/l10n.dart';
import 'package:npssolutions_mobile/pages/onboarding_page/onboarding_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LanguageController()),
      // ChangeNotifierProvider(create: (context) => MyRouterDelegate()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LanguageController languageController = Provider.of(context);

    return MaterialApp(
      title: 'NPS Solutions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: languageController.currentLocale?.locale,
      home: const OnboardingPage(),
    );
  }
}
