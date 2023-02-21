import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/repositories/dio_repo.dart';

final authRepo = _AuthRepo();

class _AuthRepo extends DioRepo {
  Future<ResponseModel?> login({
    required String username,
    required String password,
  }) async {
    return await post(
      '/api/v1/auth/login',
      data: {
        "username": username,
        "password": password,
        "rememberMe": true,
      },
      unAuth: true,
    );
  }
}
