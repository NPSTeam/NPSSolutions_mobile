import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:npssolutions_mobile/configs/app_key.dart';
import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/services/spref.dart';

import '../configs/spref_key.dart';

class DioRepo {
  static late Dio _dio;
  static late Dio _unAuthDio;
  static late BuildContext context;

  DioRepo() {
    loadDio();
  }

  static loadDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppKey.BACKEND_URL,
      headers: {
        "Authorization": "Bearer ${SPref.instance.get(SPrefKey.accessToken)}",
      },
    ));

    _unAuthDio = Dio(BaseOptions(
      baseUrl: AppKey.BACKEND_URL,
    ));
  }

  static Future<ResponseModel?> get(
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

  static Future<ResponseModel?> post(
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
