import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_collage/image_collage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/controllers/home_controller.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/personal_profile_page/controllers/personal_profile_controller.dart';
import 'package:nps_social/widgets/widget_photo_viewer.dart';
import 'package:nps_social/widgets/widget_profile_avatar.dart';

class ProfilePostContainer extends StatelessWidget {
  final UserModel? currentUser = Get.find<AuthController>().currentUser;
  final PostModel post;

  ProfilePostContainer({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    WidgetProfileAvatar(imageUrl: currentUser?.avatar ?? ''),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser?.fullName ?? 'Name',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Text(
                                // '${post.timeAgo} · ',
                                'Temp · ',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.0,
                                ),
                              ),
                              Icon(
                                Icons.public,
                                color: Colors.grey[600],
                                size: 12.0,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => print('More'),
                      icon: const Icon(Icons.more_horiz),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(post.content!),
                post.images != null
                    ? const SizedBox.shrink()
                    : const SizedBox(height: 6.0),
              ],
            ),
          ),
          post.images != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  // child: GalleryImage(
                  //   numOfShowImages: post.images?.length ?? 0,
                  //   imageUrls:
                  //       post.images?.map((e) => e.url ?? '').toList() ?? [],
                  // ),
                  // child: ImageCollapse(
                  //     imageUrls:
                  //         post.images?.map((e) => e.url ?? '').toList() ?? []))
                  child: ImageCollage(
                      images: post.images
                              ?.map((e) => Img(image: e.url ?? ''))
                              .toList() ??
                          [],
                      onClick: (clickedImg, images) {
                        Get.to(WidgetPhotoViewer(
                          imageUrls: images.map((e) => e.image).toList(),
                          startingPosition: post.images?.indexWhere(
                                  (e) => e.url == clickedImg.image) ??
                              0,
                        ));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const WidgetPhotoViewer()));

                        // ImageViewer.showImageSlider(
                        //   images: images.map((e) => e.image).toList(),
                        //   startingPosition: post.images?.indexWhere(
                        //           (e) => e.url == clickedImg.image) ??
                        //       0,
                        // );
                      }),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _PostStats(post: post),
          ),
        ],
      ),
    );
  }
}

class _PostStats extends StatelessWidget {
  final PostModel post;

  const _PostStats({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: ColorConst.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Ionicons.heart,
                size: 10.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                '${post.likes?.length ?? 0}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            Text(
              '${post.comments?.length ?? 0} Comments',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              // '${post.shares} Shares',
              '- Shares',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const Divider(thickness: 0.5),
        Row(
          children: [
            _PostButton(
              icon: Icon(
                (post.isReact ?? false)
                    ? Ionicons.heart
                    : Ionicons.heart_outline,
                color:
                    (post.isReact ?? false) ? ColorConst.red : Colors.grey[600],
                size: 20.0,
              ),
              label: "Like",
              onTap: () {
                post.isReact ?? false
                    ? Get.find<PersonalProfileController>()
                        .unlikePost(post.id ?? '')
                    : Get.find<PersonalProfileController>()
                        .likePost(post.id ?? '');
                post.isReact = !(post.isReact ?? false);
              },
            ),
            _PostButton(
              icon: Icon(
                Ionicons.chatbox_outline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: "Comment",
              onTap: () => print("Comment"),
            ),
            _PostButton(
              icon: Icon(
                Ionicons.arrow_redo_outline,
                color: Colors.grey[600],
                size: 25.0,
              ),
              label: "Share",
              onTap: () => debugPrint("Share"),
            ),
          ],
        )
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  const _PostButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4.0),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
