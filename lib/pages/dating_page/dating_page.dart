// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:nps_social/pages/dating_page/controllers/dating_controller.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../configs/theme/color_const.dart';

class DatingPage extends StatefulWidget {
  const DatingPage({super.key});

  @override
  State<DatingPage> createState() => _DatingPageState();
}

class _DatingPageState extends State<DatingPage> {
  DatingController _datingController = Get.put(DatingController());

  MapController _mapController = MapController();
  late MapZoomPanBehavior _mapZoomPanBehavior;
  MapTileLayerController _controller = MapTileLayerController();
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
        actions: [
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
                  return SfMaps(
                    layers: [
                      MapTileLayer(
                        urlTemplate: snapshot.data as String,
                        controller: _controller,
                        zoomPanBehavior: _mapZoomPanBehavior,
                        initialMarkersCount: 5,
                        markerBuilder: (context, index) => MapMarker(
                          latitude:
                              _datingController.currentPoint?.latitude ?? 0,
                          longitude:
                              _datingController.currentPoint?.longitude ?? 0,
                          child: Icon(
                            Ionicons.location_sharp,
                            color: ColorConst.blue,
                            size: 30,
                          ),
                        ),
                        markerTooltipBuilder: (context, index) =>
                            Container(height: 50, width: 100),
                        tooltipSettings: const MapTooltipSettings(
                          color: ColorConst.white,
                          strokeColor: ColorConst.red,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ],
                  );
                }

                return SpinKitThreeBounce(
                  color: ColorConst.blue,
                  size: 30,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
