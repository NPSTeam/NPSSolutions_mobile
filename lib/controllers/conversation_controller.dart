import 'package:get/get.dart';
import 'package:nps_social/models/call_model.dart';
import 'package:nps_social/models/conversation_model.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/models/message_model.dart';
import 'package:nps_social/repositories/conversation_repo.dart';

class ConversationController extends GetxController {
  List<ConversationModel>? allConversations;
  ConversationModel? selectedConversation;
  List<MessageModel> messages = [];

  ConversationController();

  Future getConversations() async {
    allConversations = await conversationRepository.getConversations();
    update();
  }

  Future getMessages(String recipientId) async {
    messages = await conversationRepository.getMessages(recipientId) ?? [];
    messages = messages.reversed.toList();
    update();
  }

  Future createMessage({
    required String senderId,
    required String recipientId,
    required String text,
    required List<ImageModel> media,
    CallModel? call,
  }) async {
    await conversationRepository.createMessage(
      senderId: senderId,
      recipientId: recipientId,
      text: text,
      media: media,
      call: call,
    );

    getMessages(recipientId);
    getConversations();
  }
}
