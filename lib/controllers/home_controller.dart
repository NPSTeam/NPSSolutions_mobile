import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/repositories/post_repo.dart';

class HomeController extends GetxController {
  List<PostModel>? allPosts;

  HomeController() {
    init();
  }

  init() async {
    allPosts = await postRepository.getPosts();
    update();
  }
}
