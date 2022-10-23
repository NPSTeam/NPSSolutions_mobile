import 'package:nps_social/models/auth_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final authRepository = _AuthRepository();

class _AuthRepository extends CrudRepository {
  Future<AuthModel?> login({
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
    return null;
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

  Future<UserModel?> register({
    required String firstName,
    required String lastName,
    required String fullName,
    required String email,
    required String password,
    required String mobile,
    required String sex,
  }) async {
    var result = await post(
      '/api/auth/register',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'fullName': fullName,
        'email': email,
        'password': password,
        'mobile': mobile,
        'sex': sex,
      },
    );
    if (result?.data != null) {
      return UserModel.fromJson(result?.data);
    }
    return null;
  }

  Future<String?> sendVerificationEmail({
    required UserModel user,
  }) async {
    var result = await post(
      '/api/auth/sendverificationemail',
      data: {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'fullName': user.fullName,
        'email': user.email,
        'password': user.password,
        'mobile': user.mobile,
        'sex': user.sex,
      },
    );
    if (result?.data != null) {
      return result?.data['message'];
    }
    return null;
  }
}
