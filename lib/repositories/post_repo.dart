import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nps_social/models/image_model.dart';
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

  Future<bool?> createPost(
      {required String content, required List<ImageModel>? images}) async {
    var result = await post(
      '/api/post/createPost',
      data: {
        'content': content,
        'images': images,
      },
    );

    debugPrint("${result?.statusCode}");

    if (result?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<List<PostModel>?> getUserPosts({required String userId}) async {
    List<PostModel>? posts;

    var result = await get('/api/post/user_posts/$userId');
    if (result?.data['posts'] != null) {
      posts = List<PostModel>.from(
          result?.data['posts'].map((e) => PostModel.fromJson(e)));
      return posts;
    }
    return null;
  }

  Future<List<PostModel>?> getSavedPosts({required String userId}) async {
    List<PostModel>? posts;

    var result = await get('/api/post/getSavePosts');
    if (result?.data['savePosts'] != null) {
      posts = List<PostModel>.from(
          result?.data['savePosts'].map((e) => PostModel.fromJson(e)));
      return posts;
    }
    return null;
  }
}
