import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/controllers/dio_repo.dart';
import 'package:npssolutions_mobile/controllers/language_controller.dart';
import 'package:npssolutions_mobile/generated/l10n.dart';
import 'package:npssolutions_mobile/router/my_router_config.dart';
import 'package:npssolutions_mobile/services/spref.dart';
import 'package:provider/provider.dart';

import 'configs/app_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SPref.init();
  AppKey.init();
  DioRepo.loadDio();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LanguageController()),
      ChangeNotifierProvider(create: (context) => AuthController(context)),
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

    return MaterialApp.router(
      title: 'NPS Solutions',
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
      locale: languageController.currentLocale?.locale,
      routerConfig: MyRouterConfig.router,
    );
  }
}
