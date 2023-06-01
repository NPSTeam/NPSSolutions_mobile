import 'dart:io';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/pages/home_page/home_page.dart';
import 'package:npssolutions_mobile/pages/onboarding_page/onboarding_page.dart';
import 'package:npssolutions_mobile/services/spref.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';

import 'configs/app_key.dart';
import 'controllers/language_controller.dart';
import 'internationalization/messages.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await dotenv.load(fileName: ".env");
  await SPref.init();
  AppKey.init();

  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = ColorConst.primary
    ..backgroundColor = Colors.white
    ..indicatorColor = ColorConst.primary
    ..textColor = Colors.grey
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = true
    ..dismissOnTap = false
    ..boxShadow = [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: const Offset(0.0, 1.0),
        blurRadius: 5.0,
        spreadRadius: 2,
      )
    ]
    ..animationDuration = const Duration(milliseconds: 400);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LanguageController _languageController = Get.put(LanguageController());
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: GetMaterialApp(
        title: "NPS Solutions",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          extensions: [
            SimpleLoadingDialogTheme(
              dialogBuilder: (context, message) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(message),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        translations: Messages(), // your translations
        locale: _languageController.currentLocale?.locale,
        // fallbackLocale: const Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
        localizationsDelegates: const [RefreshLocalizations.delegate],
        builder: EasyLoading.init(),
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
