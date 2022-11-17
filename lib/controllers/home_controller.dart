import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/repositories/post_repo.dart';
import 'package:nps_social/repositories/user_repo.dart';

class HomeController extends GetxController {
  List<PostModel>? allPosts;
  List<UserModel>? suggestionUsers;

  HomeController() {
    init();
  }

  init() async {
    await getPosts();
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
}
