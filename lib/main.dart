import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/controllers/language_controller.dart';
import 'package:npssolutions_mobile/generated/l10n.dart';
import 'package:npssolutions_mobile/pages/home_page/home_page.dart';
import 'package:npssolutions_mobile/pages/onboarding_page/onboarding_page.dart';
import 'package:npssolutions_mobile/services/spref.dart';
import 'package:provider/provider.dart';

import 'configs/app_key.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await dotenv.load(fileName: ".env");
  await SPref.init();
  AppKey.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LanguageController()),
    ],
    child: MyApp(),
  ));

  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageController>(
      builder: (_, LanguageController, ___) => GetMaterialApp(
        title: "NPS Solutions",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: LanguageController.currentLocale?.locale,
        home: GetBuilder<AuthController>(
          builder: (authController) => authController.auth != null
              ? const HomePage()
              : const OnboardingPage(),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
