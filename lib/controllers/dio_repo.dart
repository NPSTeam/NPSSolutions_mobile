import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:npssolutions_mobile/configs/app_key.dart';
import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:provider/provider.dart';

import 'auth_controller.dart';

class DioRepo {
  BuildContext context;
  late Dio _dio;

  DioRepo(this.context) {
    _dio = Dio(BaseOptions(
      baseUrl: AppKey.BACKEND_URL,
      headers: {
        "Authorization":
            "Bearer ${Provider.of<AuthController>(context, listen: true)}",
      },
    ));
  }

  Future<ResponseModel?> get(String path,
      {Map<String, dynamic>? parameters}) async {
    try {
      Response res;
      res = await _dio.get(
        path,
        queryParameters: parameters,
      );
      return ResponseModel.fromJson(res.data);
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint("${e.response?.data}");
      } else {
        debugPrint(e.message);
      }
    }

    return null;
  }
}
