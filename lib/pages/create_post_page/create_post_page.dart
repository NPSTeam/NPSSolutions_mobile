import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_collage/image_collage.dart' as image_collage;
import 'package:image_collapse/image_collapse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/pages/create_post_page/create_post_controller.dart';
import 'package:nps_social/widgets/widget_appbar_button.dart';
import 'package:nps_social/widgets/widget_profile_avatar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart'
    as image_source;

import '../../configs/palette.dart';
import '../../utils/constants.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final AuthController _authController = Get.find();
  CreatePostController _createPostController = Get.put(CreatePostController());

  final TextEditingController _contentTextEditingController =
      TextEditingController();
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.scaffold,
        foregroundColor: Palette.blue,
        title: const Text("Create Post"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: WidgetAppBarButton(
              text: "Post",
              onPressed: () async {
                await _createPostController.createPost(
                    content: _contentTextEditingController.text);
              },
            ),
          ),
        ],
      ),
      body: GetBuilder<CreatePostController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetProfileAvatar(
                          imageUrl: _authController.currentUser?.avatar ?? ''),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _contentTextEditingController,
                          decoration: const InputDecoration.collapsed(
                            hintText: "What's on your mind? ",
                          ),
                        ),
                      ),
                      ...List.generate(
                          controller.selectedImages.length,
                          (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                      controller.selectedImages[index]),
                                ),
                              )),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(
                  height: 10.0,
                  thickness: 0.5,
                ),
                TextButton.icon(
                  onPressed: () async {
                    debugPrint("Photo");
                    XFile? image = await picker.pickImage(
                        source: image_source.ImageSource.gallery);
                    controller.selectedImages.add(File(image?.path ?? ''));
                    controller.update();
                  },
                  icon: const Icon(
                    Icons.photo_library,
                    color: Colors.green,
                  ),
                  label: const Text(
                    "Photo",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
