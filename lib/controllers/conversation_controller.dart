import 'package:get/get.dart';
import 'package:nps_social/models/conversation_model.dart';
import 'package:nps_social/repositories/conversation_repo.dart';

class ConversationController extends GetxController {
  List<ConversationModel>? allConversations;

  ConversationController();

  Future getConversations() async {
    allConversations = await conversationRepository.getConversations();
    update();
  }
}
