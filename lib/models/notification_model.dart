import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/utils/datetime_convert.dart';

class NotificationModel {
  String? id;
  UserModel? user;
  String? text;
  String? content;
  String? image;
  bool? isRead;
  DateTime? createdAt;

  NotificationModel({
    this.id,
    this.user,
    this.text,
    this.content,
    this.image,
    this.isRead,
    this.createdAt,
  });

  NotificationModel.fromJson(dynamic json) {
    id = json['id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    text = json['text'];
    content = json['content'];
    image = json['image'];
    isRead = json['isRead'];
    createdAt =
        json['createdAt'] != null ? stringToDateTime(json['createdAt']) : null;
  }
}
