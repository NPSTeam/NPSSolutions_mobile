import 'package:get/get.dart';

import '../models/chat_model.dart';
import '../models/contact_model.dart';
import '../repositories/chat_repo.dart';

class ChatListController extends GetxController {
  List<ContactModel> contacts = [];
  List<ChatModel> chats = [];

  Future<bool> getContactList() async {
    final response = await chatRepo.getContactList();

    if (response?.data != null) {
      contacts = (response?.data as List)
          .map((e) => ContactModel.fromJson(e))
          .toList();

      update();
      return true;
    }

    return false;
  }

  Future<bool> getChatList() async {
    final response = await chatRepo.getChatList();

    if (response?.data != null) {
      chats =
          (response?.data as List).map((e) => ChatModel.fromJson(e)).toList();

      update();
      return true;
    }

    return false;
  }
}
