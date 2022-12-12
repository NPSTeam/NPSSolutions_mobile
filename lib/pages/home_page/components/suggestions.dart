import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/configs/theme/style_const.dart';
import 'package:nps_social/controllers/home_controller.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/personal_profile_page/controllers/personal_profile_controller.dart';
import 'package:nps_social/pages/personal_profile_page/personal_profile_page.dart';
import 'package:nps_social/widgets/widget_outlined_button.dart';

class Suggestions extends StatefulWidget {
  const Suggestions({super.key});

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  final HomeController _homeController = Get.find();
  final PersonalProfileController _profileController = Get.find();
  // bool isLoadingSuggestions = true;

  @override
  void initState() {
    // _homeController.getSuggestions().then((value) {
    //   setState(() {
    //     isLoadingSuggestions = false;
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      // if (isLoadingSuggestions) {
      //   return Container(
      //     color: Colors.white,
      //     height: 200,
      //     child: const SpinKitThreeBounce(
      //       color: ColorConst.blue,
      //       size: 30,
      //     ),
      //   );
      // }

      if ((controller.suggestionUsers?.length ?? 0) == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        color: Colors.white,
        height: 200,
        child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: controller.suggestionUsers?.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () {
                    _profileController.selectedUser =
                        controller.suggestionUsers?[index];
                    Get.to(() => const PersonalProfilePage())
                        ?.then((_) => _profileController.selectedUser = null);
                  },
                  child: _UserCard(
                    user: controller.suggestionUsers?[index] ?? UserModel(),
                  ),
                ),
              );
            }),
      );
    });
  }
}

class _UserCard extends StatefulWidget {
  final UserModel user;
  bool isFollowed = false;

  _UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<_UserCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: CachedNetworkImage(
            imageUrl: widget.user.avatar ?? '',
            height: double.infinity,
            width: 110.0,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: double.infinity,
          width: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.transparent, Colors.black26],
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        Positioned(
          left: 8.0,
          top: 8.0,
          right: 8.0,
          child: Text(
            "${widget.user.fullName}",
            style: StyleConst.boldStyle(color: ColorConst.white),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Positioned(
          left: 8.0,
          bottom: 4.0,
          right: 8.0,
          child: WidgetOutlinedButton(
            text: widget.isFollowed ? "Unfollow" : "Follow",
            onPressed: () async {
              await Get.find<HomeController>()
                  .follow(userId: widget.user.id ?? '')
                  .then((_) {
                setState(() {
                  widget.isFollowed = true;
                });
              });
            },
          ),
        ),
      ],
    );
  }
}
