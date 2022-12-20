// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/theme/style_const.dart';
import 'package:nps_social/pages/dating_page/controllers/dating_controller.dart';
import 'package:nps_social/pages/personal_profile_page/controllers/personal_profile_controller.dart';
import 'package:nps_social/pages/personal_profile_page/personal_profile_page.dart';
import 'package:nps_social/widgets/widget_toast.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../configs/theme/color_const.dart';

class DatingPage extends StatefulWidget {
  const DatingPage({super.key});

  @override
  State<DatingPage> createState() => _DatingPageState();
}

class _DatingPageState extends State<DatingPage> {
  final DatingController _datingController = Get.put(DatingController());

  final MapController _mapController = MapController();
  late MapZoomPanBehavior _mapZoomPanBehavior;
  final MapTileLayerController _controller = MapTileLayerController();
  Future<String?> getMapFuture = Future.value(null);
  Future getCurrentPointFuture = new Future.value(null);

  bool isGetCurrentPosition = true;

  @override
  void initState() {
    _mapZoomPanBehavior = MapZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePinching: true,
      minZoomLevel: 13,
      zoomLevel: 17,
      maxZoomLevel: 19.5,
      focalLatLng: MapLatLng(0, 0),
    );

    getCurrentPointFuture = _datingController.getCurrentLocation();
    getCurrentPointFuture.whenComplete(() {
      _mapZoomPanBehavior.focalLatLng = MapLatLng(
          _datingController.currentPoint?.latitude ?? 0,
          _datingController.currentPoint?.longitude ?? 0);

      setState(() {
        isGetCurrentPosition = false;
      });
    });

    getMapFuture = getBingUrlTemplate(
        'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/Aerial?output=json&uriScheme=https&include=ImageryProviders&key=AiUuAy0tRXlR8a80LacebMXSWJL-4eIwYk_mgZtH3hpk-InvuNqickrKh6-vrYHE');

    _datingController.getLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Dating",
          style: TextStyle(
            color: ColorConst.blue,
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        centerTitle: false,
        elevation: 5,
        leading: GestureDetector(
          onTap: () async {
            // setState(() {
            //   isLoadingConversationList = true;
            // });
            // _conversationController.getConversations().then((value) async {
            //   await Future.delayed(const Duration(seconds: 1)).then((value) {
            //     setState(() {
            //       isLoadingConversationList = false;
            //     });
            //   });
            // });

            // _homeController.getSuggestions();
            debugPrint("Refresh");
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/icons/dating.png",
              height: 30,
              width: 30,
            ),
          ),
        ),
        actions: const [
          // GestureDetector(
          //   onTap: () {},
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Image.asset(
          //       "assets/icons/search.png",
          //       height: 30,
          //       width: 30,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: FutureBuilder(
              future: getMapFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && isGetCurrentPosition == false) {
                  return GetBuilder<DatingController>(builder: (controller) {
                    return Stack(
                      children: [
                        SfMaps(
                          layers: [
                            MapTileLayer(
                              urlTemplate: snapshot.data as String,
                              controller: _controller,
                              zoomPanBehavior: _mapZoomPanBehavior,
                              initialMarkersCount:
                                  (controller.locations?.length ?? 0) + 1,
                              markerBuilder: (context, index) => index ==
                                      (controller.locations?.length ?? 0)
                                  ? MapMarker(
                                      latitude: _datingController
                                              .currentPoint?.latitude ??
                                          0,
                                      longitude: _datingController
                                              .currentPoint?.longitude ??
                                          0,
                                      child: Icon(
                                        Ionicons.location,
                                        color: ColorConst.blue,
                                      ),
                                    )
                                  : MapMarker(
                                      latitude:
                                          controller.locations?[index].lat ?? 0,
                                      longitude:
                                          controller.locations?[index].lng ?? 0,
                                      child: InkWell(
                                        onLongPress: () async {
                                          Get.to(() => PersonalProfilePage(
                                              userId:
                                                  controller.locations?[index]
                                                          .userId ??
                                                      ''))?.then((_) => Get.find<
                                                  PersonalProfileController>()
                                              .selectedUser = null);
                                        },
                                        child: CircleAvatar(
                                          radius: 18.0,
                                          backgroundColor: Colors.grey[200],
                                          backgroundImage: controller
                                                      .locations?[index]
                                                      .avatar !=
                                                  ''
                                              ? NetworkImage(controller
                                                      .locations?[index]
                                                      .avatar ??
                                                  '')
                                              : null,
                                        ),
                                      ),
                                    ),
                              markerTooltipBuilder: (context, index) => index ==
                                      (controller.locations?.length ?? 0)
                                  ? SizedBox.shrink()
                                  : InkWell(
                                      onTapDown: (details) async {
                                        Get.to(() => PersonalProfilePage(
                                            userId: controller
                                                    .locations?[index].userId ??
                                                ''))?.then((_) =>
                                            Get.find<
                                                    PersonalProfileController>()
                                                .selectedUser = null);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 18.0,
                                              backgroundColor: Colors.grey[200],
                                              backgroundImage: controller
                                                          .locations?[index]
                                                          .avatar !=
                                                      ''
                                                  ? NetworkImage(controller
                                                          .locations?[index]
                                                          .avatar ??
                                                      '')
                                                  : null,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              controller.locations?[index]
                                                      .fullName ??
                                                  '',
                                              style: StyleConst.boldStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              tooltipSettings: const MapTooltipSettings(
                                color: ColorConst.white,
                                strokeColor: ColorConst.blue,
                                strokeWidth: 1.0,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.shareLocation();
                              WidgetToast.showToast(
                                  message: "Share location successfully");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              // side: BorderSide(color: Colors.yellow, width: 5),
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              shadowColor: Colors.lightBlue,
                            ),
                            child: Row(
                              children: const [
                                Icon(Ionicons.navigate_outline),
                                SizedBox(width: 10),
                                Text("Share My Location"),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  });
                }

                return Center(
                  child: SpinKitPumpingHeart(
                    color: ColorConst.red,
                    size: 70,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
