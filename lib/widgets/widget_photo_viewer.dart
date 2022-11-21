import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/theme/color_const.dart';

class WidgetPhotoViewer extends StatefulWidget {
  WidgetPhotoViewer({
    super.key,
    required this.imageUrls,
    this.startingPosition = 0,
  });

  // final List<String> imageUrls = [
  //   "https://images.unsplash.com/photo-1517960413843-0aee8e2b3285?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80",
  //   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvFBa3G11OUBYADP7ouSBgwiiRzSYorF4dfg&usqp=CAU",
  // ];

  List<String> imageUrls;
  int startingPosition;

  @override
  State<WidgetPhotoViewer> createState() => _WidgetPhotoViewerState();
}

class _WidgetPhotoViewerState extends State<WidgetPhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  scrollPhysics: const BouncingScrollPhysics(),
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  initialPage: widget.startingPosition,
                ),
                items: widget.imageUrls
                    .map((e) => GestureDetector(
                          onLongPress: () {
                            Get.bottomSheet(
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Container(
                                  height: 150,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            imageUrl: e,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ))
                    .toList(),
              ),
              // child: CarouselSlider.builder(
              //   options: CarouselOptions(
              //     enableInfiniteScroll: false,
              //     reverse: false,
              //   ),
              //   itemCount: widget.imageUrls.length,
              //   itemBuilder:
              //       (BuildContext context, int itemIndex, int pageViewIndex) =>
              //           CachedNetworkImage(
              //     imageUrl: widget.imageUrls[itemIndex],
              //     progressIndicatorBuilder: (context, url, downloadProgress) =>
              //         CircularProgressIndicator(
              //       value: downloadProgress.progress,
              //     ),
              //     errorWidget: (context, url, error) => const Icon(Icons.error),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
