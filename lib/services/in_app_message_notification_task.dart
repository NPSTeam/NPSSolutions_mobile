import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:npssolutions_mobile/services/sockjs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/spref_key.dart';
import '../models/message_model.dart';
import 'notification_service.dart';

class InAppMessageNotificationTask {
  static final InAppMessageNotificationTask _singleton =
      InAppMessageNotificationTask._internal();

  factory InAppMessageNotificationTask() {
    return _singleton;
  }

  InAppMessageNotificationTask._internal();

  bool isRunning = false;
  int? currentUserId;
  List<String> contactIdList = [];
  List<String> contactNameList = [];

  bool userIdIsNotNull = false;
  bool contactIdListIsNotNull = false;

  Future<void> execute() async {
    if (isRunning) {
      debugPrint('InAppMessageNotificationTask is running');
    }

    if (!isRunning) {
      await SharedPreferences.getInstance().then((instance) async {
        if (instance.getInt(SPrefKey.userId) != null &&
            instance.getInt(SPrefKey.userId) != 0) {
          currentUserId = instance.getInt(SPrefKey.userId);
          userIdIsNotNull = true;
        } else {
          debugPrint('InAppMessageNotificationTask userId is null');
          userIdIsNotNull = false;
        }
      });
    }

    if (!isRunning && userIdIsNotNull) {
      await SharedPreferences.getInstance().then((instance) async {
        if (instance.getStringList(SPrefKey.contactIdList) != null &&
            instance.getStringList(SPrefKey.contactIdList) != []) {
          contactIdList = instance.getStringList(SPrefKey.contactIdList) ?? [];
          contactIdListIsNotNull = true;
        } else {
          debugPrint('InAppMessageNotificationTask contactIdList is null');
          contactIdListIsNotNull = false;
        }
      });
    }

    if (!isRunning && userIdIsNotNull && contactIdListIsNotNull) {
      if (!SockJS.client.isActive) {
        SockJS.client.activate();
      }

      if (SockJS.client.isActive && !isRunning) {
        try {
          for (String contactId in contactIdList) {
            SockJS.client.subscribe(
              destination:
                  '/chat-contact/userId/$currentUserId/chatId/$contactId',
              callback: (message) {
                debugPrint(message.body);

                if (message.body != null) {
                  MessageModel messageModel =
                      MessageModel.fromJson(jsonDecode(message.body!));

                  NotificationService.showNotification(
                      title: contactNameList[contactIdList.indexOf(contactId)],
                      // title: 'New message',
                      body: messageModel.value ?? '');
                }
              },
            );
          }

          debugPrint('InAppMessageNotificationTask started');
          isRunning = true;
        } on Exception catch (e) {
          isRunning = false;
        }
      }
    }
  }
}
