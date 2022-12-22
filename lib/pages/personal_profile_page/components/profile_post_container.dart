import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_collage/image_collage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/controllers/home_controller.dart';
import 'package:nps_social/models/comment_model.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/home_page/components/post_container.dart';
import 'package:nps_social/pages/personal_profile_page/controllers/personal_profile_controller.dart';
import 'package:nps_social/utils/datetime_convert.dart';
import 'package:nps_social/widgets/widget_photo_viewer.dart';
import 'package:nps_social/widgets/widget_profile_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePostContainer extends StatelessWidget {
  final PersonalProfileController _personalProfileController = Get.find();
  final UserModel? currentUser = Get.find<AuthController>().currentUser;
  final UserModel? selectedUser =
      Get.find<PersonalProfileController>().selectedUser;
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
                    WidgetProfileAvatar(
                        imageUrl:
                            selectedUser?.avatar ?? currentUser?.avatar ?? ''),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedUser?.fullName ??
                                currentUser?.fullName ??
                                'Name',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Text(
                                DateTime.now()
                                        .subtract(const Duration(days: 7))
                                        .isBefore(
                                            post.createdAt ?? DateTime.now())
                                    ? timeago.format(
                                        post.createdAt ?? DateTime.now())
                                    : dateTimeToString(
                                        post.createdAt ?? DateTime.now()),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(width: 5),
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
                    if (selectedUser == null ||
                        (selectedUser?.id == currentUser?.id))
                      PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "DELETE_POST",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(Ionicons.trash_outline),
                                Text("Delete"),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case "DELETE_POST":
                              _personalProfileController
                                  .deletePost(post.id ?? '');
                              break;
                            default:
                          }
                        },
                        child: const Icon(Icons.more_horiz),
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

class _PostStats extends StatefulWidget {
  final PostModel post;

  const _PostStats({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<_PostStats> createState() => _PostStatsState();
}

class _PostStatsState extends State<_PostStats> {
  TextEditingController _commentContentController = TextEditingController();

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
                '${widget.post.likes?.length ?? 0}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            Text(
              '${widget.post.comments?.length ?? 0} Comments',
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
                (widget.post.isReact ?? false)
                    ? Ionicons.heart
                    : Ionicons.heart_outline,
                color: (widget.post.isReact ?? false)
                    ? ColorConst.red
                    : Colors.grey[600],
                size: 20.0,
              ),
              label: "Like",
              onTap: () {
                widget.post.isReact ?? false
                    ? Get.find<PersonalProfileController>()
                        .unlikePost(widget.post.id ?? '')
                    : Get.find<PersonalProfileController>()
                        .likePost(widget.post.id ?? '');
                widget.post.isReact = !(widget.post.isReact ?? false);
              },
            ),
            _PostButton(
              icon: Icon(
                Ionicons.chatbox_outline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: "Comment",
              onTap: () {
                Get.defaultDialog(
                  title: "Comments",
                  contentPadding: const EdgeInsets.all(0),
                  content: StatefulBuilder(builder: (context, setState) {
                    return Container(
                      height: Get.height * 0.4,
                      width: Get.width * 0.8,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: List.generate(
                                  widget.post.comments?.length ?? 0,
                                  (index) => CommentListItem(
                                      comment: widget.post.comments?[index]),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                          controller:
                                              _commentContentController)),
                                  GestureDetector(
                                      onTap: () async {
                                        var content =
                                            _commentContentController.text;
                                        setState(() {
                                          widget.post.comments
                                              ?.add(CommentModel(
                                            user: Get.find<AuthController>()
                                                .currentUser,
                                            content: content,
                                          ));

                                          _commentContentController.text = '';
                                        });

                                        Get.find<HomeController>()
                                            .createComment(
                                          postId: widget.post.id ?? '',
                                          content: content,
                                          postUserId: widget.post.user.id,
                                        );
                                      },
                                      child: const Icon(Ionicons.send)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
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
