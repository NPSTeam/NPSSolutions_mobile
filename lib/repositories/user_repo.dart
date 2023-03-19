import '../models/response_model.dart';
import 'dio_repo.dart';

final userRepo = _UserRepo();

class _UserRepo extends DioRepo {
  Future<ResponseModel?> getUserProfile() async {
    return await get('/api/v1/user/profile');
  }
}
