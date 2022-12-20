import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final commentRepository = _CommentRepository();

class _CommentRepository extends CrudRepository {
  Future<bool?> likeComment({required String commentId}) async {
    var result = await patch('/api/comment/$commentId/like');
    if (result?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<bool?> unlikeComment({required String commentId}) async {
    var result = await patch('/api/comment/$commentId/unlike');
    if (result?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<bool?> createComment({
    required String postId,
    required String content,
    required String postUserId,
    String? tag,
    String? reply,
  }) async {
    var result = await post(
      '/api/comment/createComment',
      data: {
        'data': {
          'postId': postId,
          'content': content,
          'postUserId': postUserId,
        },
      },
    );

    debugPrint("${result?.statusMessage}");
    debugPrint("${result?.statusCode}");

    if (result?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }
}
