import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nps_social/controllers/home_controller.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/repositories/cloudinary_repo.dart';
import 'package:nps_social/repositories/post_repo.dart';
import 'package:nps_social/widgets/widget_snackbar.dart';

class CreatePostController extends GetxController {
  List<File> selectedImages = [];

  Future createPost({
    required String content,
  }) async {
    List<ImageModel>? uploadedImages = await cloudinaryRepository
        .uploadImages(imageFiles: selectedImages)
        .then(
      (value) async {
        if (value == null) {
          WidgetSnackbar.showSnackbar(
            title: "Some error when upload images",
            message: "Please try again.",
          );
          return null;
        }

        await postRepository
            .createPost(content: content, images: value)
            .then((value) {
          if (value == true) {
            Get.back();
            WidgetSnackbar.showSnackbar(
              title: "Done",
              message: "Create successfully.",
            );
            Get.find<HomeController>().getPosts();
          } else {
            WidgetSnackbar.showSnackbar(
              title: "Some error",
              message: "Can't create a post.",
            );
          }
        });
      },
    );

    return;
  }
}
