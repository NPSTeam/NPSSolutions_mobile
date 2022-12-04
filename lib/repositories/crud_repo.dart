import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:nps_social/configs/app_key.dart';
import 'package:nps_social/controllers/auth_controller.dart';

class CrudRepository {
  final _dio = Dio(BaseOptions(
    baseUrl: AppKey.BACKEND_URL,
    headers: {
      "Authorization": "Bearer ${Get.find<AuthController>().refreshToken}",
    },
  ));

  Future<Response?> get(String path, {Map<String, dynamic>? parameters}) async {
    try {
      Response res;
      res = await _dio.get(
        path,
        queryParameters: parameters,
        options:
            buildCacheOptions(const Duration(days: 10), forceRefresh: true),
      );
      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint("${e.response?.data}");
      } else {
        debugPrint(e.message);
      }
    }

    return null;
  }

  Future<Response?> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      Response res;
      res = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options:
            buildCacheOptions(const Duration(days: 10), forceRefresh: true),
      );
      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint("${e.response?.data}");
      } else {
        debugPrint(e.message);
      }
    }

    return null;
  }

  Future<Response?> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response res;
      res = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint("${e.response?.data}");
      } else {
        debugPrint(e.message);
      }

      return null;
    }
  }
}
