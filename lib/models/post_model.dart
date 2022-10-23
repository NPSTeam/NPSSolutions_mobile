import 'package:nps_social/models/comment_model.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/models/user_model.dart';

class PostModel {
  String? content;
  List<ImageModel>? images;
  List<UserModel>? likes;
  List<CommentModel>? comments;
  UserModel? user;

  PostModel({
    this.content,
    this.images,
    this.likes,
    this.comments,
    this.user,
  });

  PostModel.fromJson(dynamic json) {
    content = json['content'];
    images = json['images'] != null
        ? List<ImageModel>.from(
            json['images'].map((e) => ImageModel.fromJson(e)))
        : null;
    likes = json['likes'] != null
        ? List<UserModel>.from(json['likes'].map((e) => UserModel.fromJson(e)))
        : null;
    comments = json['comments'] != null
        ? List<CommentModel>.from(
            json['comments'].map((e) => CommentModel.fromJson(e)))
        : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }
}
