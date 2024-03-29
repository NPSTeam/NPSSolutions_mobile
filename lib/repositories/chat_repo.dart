import '../models/message_model.dart';
import '../models/response_model.dart';
import 'dio_repo.dart';

final chatRepo = _ChatRepo();

class _ChatRepo extends DioRepo {
  Future<ResponseModel?> getContactList() async {
    return await get('/api/v1/chat/contacts');
  }

  Future<ResponseModel?> getChatList() async {
    return await get('/api/v1/chat/chats');
  }

  Future<ResponseModel?> getChatMessages(int chatId) async {
    return await get('/api/v1/chat/chats/$chatId');
  }

  Future<ResponseModel?> sendMessage(MessageModel message) async {
    return await post('/api/v1/chat', data: message.toJson());
  }
}
