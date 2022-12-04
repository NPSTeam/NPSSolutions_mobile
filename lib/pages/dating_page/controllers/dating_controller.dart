import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nps_social/models/location_model.dart';

class DatingController extends GetxController {
  Position? currentPoint;
  List<LocationModel>? locations;

  DatingController() {}

  // Future getLocations() async {
  //   allPosts = await .getPosts();
  //   allPosts?.forEach((e) {
  //     if (e.likes?.any(
  //             (e) => e.id == Get.find<AuthController>().currentUser?.id) ??
  //         false) {
  //       e.isReact = true;
  //     }
  //   });
  //   update();
  // }

  Future getCurrentLocation() async {
    currentPoint = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    update();
  }
}
