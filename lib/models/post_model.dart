import 'package:flutter/foundation.dart';
import 'package:nps_social/models/comment_model.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/utils/datetime_convert.dart';

class PostModel {
  String? id;
  String? content;
  List<ImageModel>? images;
  List<dynamic>? likes;
  List<dynamic>? comments;
  dynamic user;
  DateTime? createdAt;
  bool? isReact;

  PostModel({
    this.id,
    this.content,
    this.images,
    this.likes,
    this.comments,
    this.user,
    this.createdAt,
    this.isReact,
  });

  PostModel.fromJson(dynamic json) {
    id = json['_id'];
    content = json['content'];
    images = json['images'] != null
        ? List<ImageModel>.from(
            json['images'].map((e) => ImageModel.fromJson(e)))
        : null;
    if (json['likes'] != null && json['likes']?.length != 0) {
      likes = (json['likes']?[0] ?? '') is String
          ? List<String>.from(json['likes'].map((e) => e))
          : List<UserModel>.from(
              json['likes'].map((e) => UserModel.fromJson(e)));
    }
    if (json['comments'] != null && json['comments']?.length != 0) {
      comments = (json['comments']?[0] ?? '') is String
          ? List<String>.from(json['comments'].map((e) => e))
          : List<CommentModel>.from(
              json['comments'].map((e) => CommentModel.fromJson(e)));
    }
    createdAt = utcToLocalDateTime(stringToDateTime(json['createdAt']));
    user = json['user'] != null
        ? (json['user'] is String
            ? json['user']
            : UserModel.fromJson(json['user']))
        : null;
  }
}
