import 'package:nps_social/models/auth_model.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final authRepository = _AuthRepository();

class _AuthRepository extends CrudRepository {
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    var result = await post(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    if (result?.data != null) {
      return AuthModel.fromJson(result?.data);
    }
    return AuthModel();
  }

  Future<AuthModel?> checkLogin({
    required String accessToken,
    required String refreshToken,
  }) async {
    var result = await post(
      '/api/auth/checkLogin',
      data: {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      },
    );
    if (result?.data != null) {
      return AuthModel.fromJson(result?.data);
    }
    return null;
  }
}
