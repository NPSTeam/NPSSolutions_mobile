import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/services/sockjs.dart';

import '../controllers/auth_controller.dart';
import '../models/contact_model.dart';
import '../models/message_model.dart';
import '../repositories/chat_repo.dart';
import 'notification_service.dart';

class MessageNotificationTask {
  static SockJS sockJS = SockJS();

  static Future<void> execute() async {
    final response = await chatRepo.getContactList();

    // if (response?.data != null) {
    //   List<ContactModel> contacts = (response?.data as List)
    //       .map((e) => ContactModel.fromJson(e))
    //       .toList();

    //   if (sockJS.client.isActive) {
    //     sockJS.client.deactivate();
    //   }

    //   if (sockJS.client.isActive) {
    //     sockJS.client.activate();

    //     for (ContactModel contact in contacts) {
    //       sockJS.client.subscribe(
    //         destination:
    //             '/chat-contact/userId/${Get.find<AuthController>().auth?.currentUser?.id}/chatId/${contact.id}',
    //         callback: (message) {
    //           debugPrint(message.body);

    //           if (message.body != null) {
    //             MessageModel messageModel =
    //                 MessageModel.fromJson(jsonDecode(message.body!));

    //             NotificationService.showNotification(
    //                 title: contact.name ?? 'New message',
    //                 body: messageModel.value ?? '');
    //           }
    //         },
    //       );
    //     }
    //   }
    // }
  }
}
