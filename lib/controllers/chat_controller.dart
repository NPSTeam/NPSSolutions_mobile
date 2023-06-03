import 'package:get/get.dart';

import '../models/message_model.dart';
import '../repositories/chat_repo.dart';

class ChatController extends GetxController {
  List<MessageModel> messages = [];

  Future<bool> getMessages(int chatId) async {
    messages = [];

    final response = await chatRepo.getChatMessages(chatId);
    if (response?.data != null) {
      messages = (response?.data as List)
          .map((e) => MessageModel.fromJson(e))
          .toList();
      update();
      return true;
    }

    return false;
  }
}
