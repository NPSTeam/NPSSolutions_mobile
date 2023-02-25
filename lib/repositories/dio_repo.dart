import 'dart:convert';

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

  DioRepo() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            try {
              await _dio
                  .post("${AppKey.BACKEND_URL}/api/v1/auth/refresh-token",
                      data: jsonEncode({
                        "idRefreshToken":
                            getx.Get.find<AuthController>().auth?.refreshToken
                      }))
                  .then((value) async {
                if (value.statusCode == 200) {
                  //get new tokens ...
                  debugPrint(
                      "NEW ACCESS TOKEN - ${value.data['access_token']}");
                  debugPrint(
                      "NEW REFRESH TOKEN - ${value.data['refresh_token']}");

                  //set bearer
                  await getx.Get.find<AuthController>().updateTokenToLocal(
                    accessToken: value.data['access_token'],
                    refreshToken: value.data['access_token'],
                  );

                  e.requestOptions.headers["Authorization"] =
                      "Bearer ${value.data['access_token']}";

                  //create request with new access token
                  final opts = Options(
                      method: e.requestOptions.method,
                      headers: e.requestOptions.headers);
                  final cloneReq = await _dio.request(e.requestOptions.path,
                      options: opts,
                      data: e.requestOptions.data,
                      queryParameters: e.requestOptions.queryParameters);

                  return handler.resolve(cloneReq);
                }
              });
            } catch (e) {}
          }

          return handler.next(e); //continue
        },
      ),
    );
  }

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
