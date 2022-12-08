import 'package:nps_social/models/call_model.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/utils/datetime_convert.dart';

class ConversationModel {
  String? id;
  List<ImageModel>? media;
  List<UserModel>? recipients;
  String? text;
  DateTime? updatedAt;
  CallModel? call;

  ConversationModel({
    this.id,
    this.media,
    this.recipients,
    this.text,
    this.updatedAt,
  });

  ConversationModel.fromJson(dynamic json) {
    id = json['_id'];
    media = json['media'] != null
        ? List<ImageModel>.from(
            json['media'].map((e) => ImageModel.fromJson(e)))
        : null;
    recipients = json['recipients'] != null
        ? List<UserModel>.from(
            json['recipients'].map((e) => UserModel.fromJson(e)))
        : null;
    text = json['text'];
    updatedAt =
        json['updatedAt'] != null ? stringToDateTime(json['updatedAt']) : null;
    call = json['call'] != null ? CallModel.fromJson(json['call']) : null;
  }
}
