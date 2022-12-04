import 'package:nps_social/models/location_model.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final locationRepository = _LocationRepository();

class _LocationRepository extends CrudRepository {
  Future<List<LocationModel>?> getLocations() async {
    List<LocationModel>? locations;

    var result = await get('/api/location/list');
    if (result?.data['datas'] != null) {
      locations = List<LocationModel>.from(
          result?.data['datas'].map((e) => LocationModel.fromJson(e)));
      return locations;
    }
    return null;
  }
}
