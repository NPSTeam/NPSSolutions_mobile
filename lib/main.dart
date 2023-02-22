import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/pages/home_page/home_page.dart';
import 'package:npssolutions_mobile/pages/onboarding_page/onboarding_page.dart';
import 'package:npssolutions_mobile/services/spref.dart';

import 'configs/app_key.dart';
import 'controllers/language_controller.dart';
import 'internationalization/messages.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await dotenv.load(fileName: ".env");
  await SPref.init();
  AppKey.init();

  // runApp(MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(create: (context) => LanguageController()),
  //   ],
  //   child: MyApp(),
  // ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LanguageController _languageController = Get.put(LanguageController());
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "NPS Solutions",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      translations: Messages(), // your translations
      locale: _languageController.currentLocale
          ?.locale, // translations will be displayed in that locale
      // fallbackLocale: const Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
      home: GetBuilder<AuthController>(
        builder: (authController) => authController.auth != null
            ? const HomePage()
            : const OnboardingPage(),
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
