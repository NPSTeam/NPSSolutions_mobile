import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_collage/image_collage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/configs/theme/style_const.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/controllers/home_controller.dart';
import 'package:nps_social/models/comment_model.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/pages/personal_profile_page/controllers/personal_profile_controller.dart';
import 'package:nps_social/pages/personal_profile_page/personal_profile_page.dart';
import 'package:nps_social/utils/datetime_convert.dart';
import 'package:nps_social/widgets/widget_photo_viewer.dart';
import 'package:nps_social/widgets/widget_profile_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostContainer extends StatefulWidget {
  final PostModel post;

  const PostContainer({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
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
                _PostHeader(post: widget.post),
                const SizedBox(height: 4.0),
                Text(widget.post.content!),
                widget.post.images != null
                    ? const SizedBox.shrink()
                    : const SizedBox(height: 6.0),
              ],
            ),
          ),
          widget.post.images != null
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
                      images: widget.post.images
                              ?.map((e) => Img(image: e.url ?? ''))
                              .toList() ??
                          [],
                      onClick: (clickedImg, images) {
                        Get.to(WidgetPhotoViewer(
                          imageUrls: images.map((e) => e.image).toList(),
                          startingPosition: widget.post.images?.indexWhere(
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
            child: _PostStats(post: widget.post),
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final PostModel post;

  const _PostHeader({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              Get.find<PersonalProfileController>().selectedUser = post.user;
              Get.to(
                () => const PersonalProfilePage(),
                transition: Transition.cupertino,
              )?.then((_) {
                Get.find<PersonalProfileController>().selectedUser = null;
              });
            },
            child: WidgetProfileAvatar(imageUrl: post.user?.avatar ?? '')),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.user?.fullName ?? 'Name',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    DateTime.now()
                            .subtract(const Duration(days: 7))
                            .isBefore(post.createdAt ?? DateTime.now())
                        ? timeago.format(post.createdAt ?? DateTime.now())
                        : dateTimeToString(post.createdAt ?? DateTime.now()),
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
        IconButton(
          onPressed: () => print('More'),
          icon: const Icon(Icons.more_horiz),
        ),
      ],
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
                    ? Get.find<HomeController>()
                        .unlikePost(widget.post.id ?? '')
                    : Get.find<HomeController>().likePost(widget.post.id ?? '');
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
                showGeneralDialog(
                  barrierLabel: "Comments",
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionDuration: const Duration(milliseconds: 500),
                  context: context,
                  pageBuilder: (context, anim1, anim2) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          Container(
                            height: 400,
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(left: 12, right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox.expand(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: List.generate(
                                          widget.post.comments?.length ?? 0,
                                          (index) => CommentListItem(
                                              comment:
                                                  widget.post.comments?[index]),
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
                                                await Get.find<HomeController>()
                                                    .createComment(
                                                  postId: widget.post.id ?? '',
                                                  content:
                                                      _commentContentController
                                                          .text,
                                                  postUserId:
                                                      widget.post.user.id,
                                                );
                                              },
                                              child: const Icon(Ionicons.send)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return SlideTransition(
                      position: Tween(
                              begin: const Offset(0, 1),
                              end: const Offset(0, 0))
                          .chain(CurveTween(curve: Curves.easeOutCirc))
                          .animate(anim1),
                      child: child,
                    );
                  },
                );

                // Get.dialog(Container(
                //   height: 100,
                //   width: 200,
                //   color: Colors.red,
                // ));
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

class CommentListItem extends StatefulWidget {
  CommentModel comment;

  CommentListItem({super.key, required this.comment});

  @override
  State<CommentListItem> createState() => _CommentListItemState();
}

class _CommentListItemState extends State<CommentListItem> {
  bool isLikedComment = false;
  int likeCount = 0;

  @override
  void initState() {
    widget.comment.likes?.forEach((e) {
      if (e.id == Get.find<AuthController>().currentUser?.id) {
        setState(() {
          isLikedComment = true;
        });
      }
    });

    likeCount = widget.comment.likes?.length ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          if (widget.comment.reply != null) const SizedBox(width: 20),
          CircleAvatar(
            radius: 18.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: widget.comment.user?.avatar != ''
                ? NetworkImage(widget.comment.user?.avatar ?? '')
                : null,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.comment.user?.fullName ?? '',
                      style: StyleConst.boldStyle()),
                  Text(
                    widget.comment.content ?? '',
                    style: StyleConst.regularStyle(),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  if (isLikedComment) {
                    likeCount--;
                    Get.find<HomeController>()
                        .unlikeComment(widget.comment.id ?? '');
                  } else {
                    likeCount++;
                    Get.find<HomeController>()
                        .likeComment(widget.comment.id ?? '');
                  }

                  setState(() {
                    isLikedComment = !isLikedComment;
                  });
                },
                child: Icon(
                  isLikedComment ? Ionicons.heart : Ionicons.heart_outline,
                  color: isLikedComment ? ColorConst.red : Colors.grey[600],
                  size: 20,
                ),
              ),
              Text(
                "$likeCount",
                style: StyleConst.regularStyle(),
              ),
            ],
          ),
        ],
      ),
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
