import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/repositories/dio_repo.dart';
import 'package:path/path.dart' as p;

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

  Future<ResponseModel?> register({
    required String username,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required DateTime birthday,
    required String avatarFilePath,
  }) async {
    File imageFile = File(avatarFilePath);
    String base64String =
        "data:image/${p.extension(avatarFilePath).replaceFirst('.', '')};base64,${base64Encode(await imageFile.readAsBytes())}";

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
  }
}
