import 'package:nps_social/models/call_model.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/utils/datetime_convert.dart';

class MessageModel {
  String? id;
  String? conversationId;
  String? senderId;
  String? recipientId;
  String? text;
  List<ImageModel>? media;
  CallModel? call;
  DateTime? createdAt;

  MessageModel({
    this.id,
    this.conversationId,
    this.senderId,
    this.recipientId,
    this.text,
    this.media,
    this.call,
    this.createdAt,
  });

  MessageModel.fromJson(dynamic json) {
    id = json['_id'];
    conversationId = json['conversation'];
    senderId = json['sender'];
    recipientId = json['recipient'];
    text = json['text'];
    media = (json['media'] != null && json['media']?.length != 0)
        ? List<ImageModel>.from(
            json['media'].map((e) => ImageModel.fromJson(e)))
        : null;
    call = json['call'] != null ? CallModel.fromJson(json['call']) : null;
    createdAt = utcToLocalDateTime(stringToDateTime(json['createdAt']));
  }
}
