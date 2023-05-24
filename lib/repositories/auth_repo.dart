import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:npssolutions_mobile/helpers/util_function.dart';
import 'package:path/path.dart' as p;

import '../models/response_model.dart';
import 'dio_repo.dart';

final authRepo = _AuthRepo();

class _AuthRepo extends DioRepo {
  Future<ResponseModel?> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    return await post(
      '/api/v1/auth/login',
      data: {
        "username": username,
        "password": password,
        "rememberMe": rememberMe,
      },
      unAuth: true,
    );
  }

  Future<ResponseModel?> register({
    required String username,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required DateTime birthday,
    required String avatarFilePath,
  }) async {
    try {
      File imageFile = File(avatarFilePath);
      String base64String = await UtilFunction.fileToBase64(imageFile);

      return await post(
        '/api/v1/auth/register',
        data: {
          "username": username,
          "phone": phone,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "birthDay": '$birthday',
          "fileContent": base64String,
          "fileName": "$username${p.extension(avatarFilePath)}",
        },
        unAuth: true,
      );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
