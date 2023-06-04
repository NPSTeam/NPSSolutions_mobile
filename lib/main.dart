import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/pages/home_page/home_page.dart';
import 'package:npssolutions_mobile/pages/onboarding_page/onboarding_page.dart';
import 'package:npssolutions_mobile/repositories/chat_repo.dart';
import 'package:npssolutions_mobile/services/in_app_message_notification_task.dart';
import 'package:npssolutions_mobile/services/message_notification_task.dart';
import 'package:npssolutions_mobile/services/notification_service.dart';
import 'package:npssolutions_mobile/services/sockjs.dart';
import 'package:npssolutions_mobile/services/spref.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';

import 'configs/app_key.dart';
import 'controllers/language_controller.dart';
import 'internationalization/messages.dart';
import 'models/contact_model.dart';
import 'models/message_model.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     debugPrint("Native called background task: $task");

//     try {
//       if (Get.find<AuthController>().auth?.currentUser?.id == null) {
//         await Future.delayed(const Duration(seconds: 5));
//       }
//     } on Exception catch (e) {
//       await Future.delayed(const Duration(seconds: 5));
//     }

//     final response = await chatRepo.getContactList();

//     if (response?.data != null) {
//       List<ContactModel> contacts = (response?.data as List)
//           .map((e) => ContactModel.fromJson(e))
//           .toList();

//       if (sockJS.client.isActive) {
//         sockJS.client.deactivate();
//       }

//       if (sockJS.client.isActive) {
//         sockJS.client.activate();

//         for (ContactModel contact in contacts) {
//           sockJS.client.subscribe(
//             destination:
//                 '/chat-contact/userId/${Get.find<AuthController>().auth?.currentUser?.id}/chatId/${contact.id}',
//             callback: (message) {
//               debugPrint(message.body);

//               if (message.body != null) {
//                 MessageModel messageModel =
//                     MessageModel.fromJson(jsonDecode(message.body!));

//                 NotificationService.showNotification(
//                     title: contact.name ?? 'New message',
//                     body: messageModel.value ?? '');
//               }
//             },
//           );
//         }
//       }
//     }

//     return Future.value(true);
//   });
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await dotenv.load(fileName: ".env");
  await SPref.init();
  AppKey.init();
  final AuthController _authController = Get.put(AuthController());
  SockJS.connect();
  await NotificationService.init();
  // BackgroundNotificationService.init();
  await initializeService();
  // InAppMessageNotificationTask.execute();

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

  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);

  runApp(MyApp());

  // Workmanager().registerOneOffTask(
  //   "messageNotification",
  //   "Message Notification",
  //   backoffPolicy: BackoffPolicy.exponential,
  //   backoffPolicyDelay: Duration(seconds: 10),
  //   initialDelay: const Duration(seconds: 10),
  // );

  // Workmanager().registerPeriodicTask(
  //   "messageNotification",
  //   "Message Notification",
  //   initialDelay: const Duration(seconds: 10),
  //   frequency: const Duration(seconds: 5),
  // );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bring to foreground
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    // flutterLocalNotificationsPlugin.show(
    //   888,
    //   'COOL SERVICE',
    //   'Awesome ${DateTime.now()}',
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'my_foreground',
    //       'MY FOREGROUND SERVICE',
    //       icon: 'ic_bg_service_small',
    //       ongoing: true,
    //     ),
    //   ),
    // );

    debugPrint('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );

    // InAppMessageNotificationTask.execute();
    InAppMessageNotificationTask().execute();
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LanguageController _languageController = Get.put(LanguageController());

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
