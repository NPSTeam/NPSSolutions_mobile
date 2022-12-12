import 'dart:io';

import 'package:nps_social/models/call_model.dart';
import 'package:nps_social/models/conversation_model.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/models/message_model.dart';
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

  Future<List<MessageModel>?> getMessages(
      {required String recipientId, int? page}) async {
    List<MessageModel>? messages;

    var result =
        await get('/api/message/$recipientId?limit=${(page ?? 0) * 9}');
    if (result?.data['messages'] != null) {
      messages = List<MessageModel>.from(
          result?.data['messages'].map((e) => MessageModel.fromJson(e)));
      return messages;
    }
    return null;
  }

  Future<bool?> createMessage({
    required String senderId,
    required String recipientId,
    required String text,
    required List<ImageModel> media,
    CallModel? call,
  }) async {
    Map<String, dynamic> input = {
      'sender': senderId,
      'recipient': recipientId,
      'text': text,
      'media': media,
    };

    if (call != null) {
      input['call'] = {
        'video': call.video,
        'times': call.times,
      };
    }

    var result = await post(
      '/api/message/createMessage',
      data: {
        'msg': input,
      },
    );

    if (result?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }
}
