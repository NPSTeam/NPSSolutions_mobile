import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/repositories/comment_repo.dart';
import 'package:nps_social/repositories/post_repo.dart';
import 'package:nps_social/repositories/user_repo.dart';
import 'package:nps_social/services/socket_client.dart';

class HomeController extends GetxController {
  List<PostModel>? allPosts;
  List<UserModel>? suggestionUsers;

  HomeController() {
    init();
  }

  init() async {
    // await getPosts();
    SocketClient.socket.on('likeToClient', (data) => getPosts());
    SocketClient.socket.on('unLikeToClient', (data) => getPosts());
  }

  Future getPosts() async {
    allPosts = await postRepository.getPosts();
    allPosts?.forEach((e) {
      if (e.likes?.any(
              (e) => e.id == Get.find<AuthController>().currentUser?.id) ??
          false) {
        e.isReact = true;
      }
    });
    update();
  }

  Future likePost(String postId) async {
    var success = await postRepository.likePost(postId: postId);
    if (success == true) {
      await getPosts();
    }
  }

  Future unlikePost(String postId) async {
    var success = await postRepository.unlikePost(postId: postId);
    if (success == true) {
      await getPosts();
    }
  }

  Future getSuggestions() async {
    suggestionUsers = await userRepository.getSuggestions();
    update();
  }

  Future follow({required String userId}) async {
    await userRepository.follow(userId: userId);
    return;
  }

  Future unfollow({required String userId}) async {
    await userRepository.unfollow(userId: userId);
    return;
  }

  Future likeComment(String commentId) async {
    var success = await commentRepository.likeComment(commentId: commentId);
    if (success == true) {
      await getPosts();
    }
  }

  Future unlikeComment(String commentId) async {
    var success = await commentRepository.unlikeComment(commentId: commentId);
    if (success == true) {
      await getPosts();
    }
  }

  Future createComment({
    required String postId,
    required String content,
    required String postUserId,
  }) async {
    var success = await commentRepository.createComment(
        postId: postId, content: content, postUserId: postUserId);
    if (success == true) {
      await getPosts();
    }
  }

  Future savePost(String postId) async {
    var success = await postRepository.savePost(postId: postId);
    if (success == true) {
      await getPosts();
    }
  }

  Future unSavePost(String postId) async {
    var success = await postRepository.unSavePost(postId: postId);
    if (success == true) {
      await getPosts();
    }
  }
}
