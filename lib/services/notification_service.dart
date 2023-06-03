import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  // final DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings(
  //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // final LinuxInitializationSettings initializationSettingsLinux =
  //     LinuxInitializationSettings(defaultActionName: 'Open notification');

  static init() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsDarwin,
      // macOS: initializationSettingsDarwin,
      // linux: initializationSettingsLinux,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static showNotification({
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channel id',
      'channel name',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(999999999), title, body, notificationDetails,
        payload: 'item x');
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }
}
