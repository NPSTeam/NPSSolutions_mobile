import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/repositories/post_repo.dart';

class PersonalProfileController extends GetxController {
  UserModel? selectedUser;
  List<PostModel>? userPostList = [];
  List<PostModel>? savedPostList = [];

  PersonalProfileController();

  Future fetchUserPosts() async {
    userPostList = await postRepository.getUserPosts(
        userId: selectedUser?.id ??
            Get.find<AuthController>().currentUser?.id ??
            '');
    userPostList?.forEach((e) {
      if (e.likes
              ?.any((e) => e == Get.find<AuthController>().currentUser?.id) ??
          false) {
        e.isReact = true;
      }
    });
    update();
  }

  Future fetchSavedPosts() async {
    savedPostList = await postRepository.getSavedPosts(
        userId: selectedUser?.id ??
            Get.find<AuthController>().currentUser?.id ??
            '');
    savedPostList?.forEach((e) {
      if (e.likes
              ?.any((e) => e == Get.find<AuthController>().currentUser?.id) ??
          false) {
        e.isReact = true;
      }
    });
    update();
  }

  Future likePost(String postId) async {
    var success = await postRepository.likePost(postId: postId);
    if (success == true) {
      await fetchUserPosts();
      await fetchSavedPosts();
      update();
    }
  }

  Future unlikePost(String postId) async {
    var success = await postRepository.unlikePost(postId: postId);
    if (success == true) {
      await fetchUserPosts();
      await fetchSavedPosts();
      update();
    }
  }
}
