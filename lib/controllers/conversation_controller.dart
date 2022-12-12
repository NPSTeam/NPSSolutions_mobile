import 'package:get/get.dart';
import 'package:nps_social/models/call_model.dart';
import 'package:nps_social/models/conversation_model.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/models/message_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/repositories/conversation_repo.dart';
import 'package:nps_social/services/socket_client.dart';

class ConversationController extends GetxController {
  List<ConversationModel>? allConversations;
  ConversationModel? selectedConversation;
  List<MessageModel> messages = [];
  UserModel? recipient;
  int page = 2;

  ConversationController() {
    init();
  }

  init() async {
    SocketClient.socket.on('addMessageToClient', (data) {
      getMessages();
      getConversations();
    });
  }

  Future getConversations() async {
    allConversations = await conversationRepository.getConversations();
    update();
  }

  Future getMessages() async {
    messages = await conversationRepository.getMessages(
            recipientId: recipient?.id ?? '', page: page) ??
        [];
    update();
  }

  Future createMessage({
    required String senderId,
    required String recipientId,
    required String text,
    required List<ImageModel> media,
    CallModel? call,
  }) async {
    SocketClient.socket.emit(
      'addMessage',
      {
        'sender': senderId,
        'recipient': recipientId,
        'text': text,
        'media': media,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
    await conversationRepository.createMessage(
      senderId: senderId,
      recipientId: recipientId,
      text: text,
      media: media,
      call: call,
    );

    getMessages();
    getConversations();
  }
}
