import 'package:nps_social/models/conversation_model.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final conversationRepository = _ConversationRepository();

class _ConversationRepository extends CrudRepository {
  Future<List<ConversationModel>?> getConversations() async {
    List<ConversationModel>? conversations;

    var result = await get('/api/message/conversations');
    if (result?.data['conversations'] != null) {
      conversations = List<ConversationModel>.from(result?.data['conversations']
          .map((e) => ConversationModel.fromJson(e)));
      return conversations;
    }
    return null;
  }
}
