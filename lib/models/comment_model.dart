import 'package:nps_social/models/user_model.dart';

class CommentModel {
  String? postId;
  String? content;
  CommentModel? reply;
  List<UserModel>? likes;
  UserModel? user;

  CommentModel({
    this.postId,
    this.content,
    this.reply,
    this.likes,
  });

  CommentModel.fromJson(dynamic json) {
    postId = json['postId'];
    content = json['content'];
    // reply = json['reply'];
    likes = json['likes'] != null
        ? List<UserModel>.from(json['likes'].map((e) => UserModel.fromJson(e)))
        : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['postId'] = postId;
    map['content'] = content;
    map['reply'] = reply;
    return map;
  }
}
