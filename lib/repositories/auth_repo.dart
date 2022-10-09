import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final authRepository = _AuthRepository();

class _AuthRepository extends CrudRepository {
  Future<UserModel> login(
      {required String email, required String password}) async {
    var result = await post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    if (result?.data != null) {
      return UserModel.fromJson(result?.data);
    }
    return UserModel();
  }
}
