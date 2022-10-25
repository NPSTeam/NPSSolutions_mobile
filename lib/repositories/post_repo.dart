import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final postRepository = _PostRepository();

class _PostRepository extends CrudRepository {
  Future<List<PostModel>?> getPosts() async {
    List<PostModel>? posts;

    var result = await get('/api/post/getPosts');
    if (result?.data['posts'] != null) {
      posts = List<PostModel>.from(
          result?.data['posts'].map((e) => PostModel.fromJson(e)));
      return posts;
    }
    return null;
  }

  Future<bool?> likePost({required String postId}) async {
    var result = await patch('/api/post/$postId/like');
    if (result?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<bool?> unlikePost({required String postId}) async {
    var result = await patch('/api/post/$postId/unlike');
    if (result?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }
}
