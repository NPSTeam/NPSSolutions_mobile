import 'package:nps_social/models/user_model.dart';

class CommentModel {
  String? id;
  String? postId;
  String? content;
  String? reply;
  List<UserModel>? likes;
  UserModel? user;
  UserModel? tag;

  CommentModel({
    this.id,
    this.postId,
    this.content,
    this.reply,
    this.likes,
    this.user,
    this.tag,
  });

  CommentModel.fromJson(dynamic json) {
    id = json['_id'];
    postId = json['postId'];
    content = json['content'];
    reply = json['reply'];
    likes = json['likes'] != null
        ? List<UserModel>.from(json['likes'].map((e) => UserModel.fromJson(e)))
        : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    tag = json['tag'] != null ? UserModel.fromJson(json['tag']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['postId'] = postId;
    map['content'] = content;
    map['reply'] = reply;
    return map;
  }
}
