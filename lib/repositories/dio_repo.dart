import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:npssolutions_mobile/configs/app_key.dart';
import 'package:npssolutions_mobile/models/response_model.dart';

import '../controllers/auth_controller.dart';

class DioRepo {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppKey.BACKEND_URL,
    headers: {
      "Authorization":
          "Bearer ${getx.Get.find<AuthController>().auth?.accessToken}",
    },
  ));

  final Dio _unAuthDio = Dio(BaseOptions(baseUrl: AppKey.BACKEND_URL));

  Future<ResponseModel?> get(
    String path, {
    Map<String, dynamic>? parameters,
    bool unAuth = false,
  }) async {
    try {
      Response res;

      res = unAuth
          ? await _unAuthDio.get(
              path,
              queryParameters: parameters,
            )
          : await _dio.get(
              path,
              queryParameters: parameters,
            );

      debugPrint("${res.data}");
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

  Future<ResponseModel?> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool unAuth = false,
  }) async {
    try {
      Response res;
      res = unAuth
          ? await _unAuthDio.post(
              path,
              data: data,
              queryParameters: queryParameters,
            )
          : await _dio.post(
              path,
              data: data,
              queryParameters: queryParameters,
            );

      debugPrint("${res.data}");
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
