import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/location_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/repositories/location_repo.dart';
import 'package:nps_social/repositories/user_repo.dart';

class DatingController extends GetxController {
  Position? currentPoint;
  List<LocationModel>? locations;

  DatingController() {}

  Future getLocations() async {
    locations = await locationRepository.getLocations();
    locations?.removeWhere(
        (e) => e.userId == Get.find<AuthController>().currentUser?.id);
    update();
  }

  Future getCurrentLocation() async {
    currentPoint = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    update();
  }

  Future<UserModel?> getProfileByUserId(String userId) async {
    return await userRepository.getProfileByUserId(userId: userId);
  }

  Future<bool?> shareLocation() async {
    return await locationRepository.createLocation(
        lat: currentPoint?.latitude ?? 0, lng: currentPoint?.longitude ?? 0);
  }
}
