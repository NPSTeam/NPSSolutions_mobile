import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_collage/image_collage.dart';
import 'package:image_collapse/image_collapse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/widgets/widget_profile_avatar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import '../../configs/palette.dart';
import '../../utils/constants.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final AuthController _authController = Get.find();
  TextEditingController _contentTextEditingController = TextEditingController();
  List<XFile>? images;

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
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Post"),
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetProfileAvatar(
                      imageUrl: _authController.currentUser?.avatar ?? ''),
                  const TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "What's on your mind? ",
                    ),
                  ),
                ],
              ),
            ),
          ),
          PhotoView(imageProvider: AssetImage(images?.first.path ?? '')),
          ImageCollage(
              images: images?.map((e) => Img(image: e.path)).toList() ?? [],
              onClick: (clickedImg, images) {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) =>
                //         ImageViewer(clickedImg: clickedImg, images: images)));
              }),
          ImageCollapse(imageUrls: images!.map((e) => e.path).toList() ?? []),
          // ImageCollapse(imageUrls: [
          //   "https://firebasestorage.googleapis.com/v0/b/be-beauty-app.appspot.com/o/avatar.jpg?alt=media&token=4cb911b2-3282-4aea-b03a-0ab9b681602a"
          // ]),
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
                  images = await ImagePicker().pickMultiImage();
                  debugPrint("${await getExternalStorageDirectory()}");
                  images?.forEach((e) => debugPrint(
                      File("/storage/emulated/0/Android${e.path}").path));
                  setState(() {});
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
      ),
    );
  }
}
