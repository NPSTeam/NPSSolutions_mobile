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
    _unAuthDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("Request: ${options.method} ${options.path}");
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          debugPrint("Response: $response");
          return handler.next(response);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) {
          debugPrint("Error: $e");
          debugPrint("Error Response: ${e.response}");
          return handler.next(e);
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('----------------------------------------');
          debugPrint("Request: ${options.method} ${options.path}");
          debugPrint("Request Body: ${options.data}");

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          debugPrint("Response: $response");
          return handler.next(response);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) async {
          debugPrint("Error: $e");
          debugPrint("Error Response: ${e.response}");
          if (e.response?.statusCode == 401) {
            debugPrint(
                "Access token - ${e.requestOptions.headers['Authorization']}");
            try {
              await Dio(BaseOptions(
                baseUrl: AppKey.BACKEND_URL,
                headers: {
                  "Authorization":
                      "Bearer ${getx.Get.find<AuthController>().auth?.accessToken}",
                },
              )).post(
                "${AppKey.BACKEND_URL}/api/v1/auth/refresh-token",
                data: {
                  "idRefreshToken":
                      getx.Get.find<AuthController>().auth?.refreshToken
                },
              ).then((value) async {
                debugPrint("Refresh token successfully - ${value.data}");
                if (value.statusCode == 200) {
                  debugPrint(
                      "NEW ACCESS TOKEN - ${value.data['data']['access_token']}");
                  debugPrint(
                      "NEW REFRESH TOKEN - ${value.data['data']['refresh_token']}");

                  // Set tokens
                  if (value.data['data']['access_token'] != null &&
                      value.data['data']['access_token'] != '' &&
                      value.data['data']['refresh_token'] != null &&
                      value.data['data']['refresh_token'] != '') {
                    await getx.Get.find<AuthController>().updateTokenToLocal(
                      accessToken: value.data['data']['access_token'],
                      refreshToken: value.data['data']['refresh_token'],
                    );

                    e.requestOptions.headers["Authorization"] =
                        "Bearer ${value.data['data']['access_token']}";

                    _dio.options.headers["Authorization"] =
                        "Bearer ${value.data['data']['access_token']}";
                  }

                  // Resend request with new access token
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
            } catch (e) {
              debugPrint("Refresh token failed - $e");
              await getx.Get.find<AuthController>().logout();
            }
          }

          // return handler.next(e); //continue
        },
      ),
    );
  }

  Future<ResponseModel?> get(
    String path, {
    Map<String, dynamic>? parameters,
    bool unAuth = false,
  }) async {
    _dio.options.headers["Authorization"] =
        "Bearer ${getx.Get.find<AuthController>().auth?.accessToken}";

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
    _dio.options.headers["Authorization"] =
        "Bearer ${getx.Get.find<AuthController>().auth?.accessToken}";

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

  Future<ResponseModel?> delete(
    String path, {
    Map<String, dynamic>? parameters,
    bool unAuth = false,
  }) async {
    _dio.options.headers["Authorization"] =
        "Bearer ${getx.Get.find<AuthController>().auth?.accessToken}";

    try {
      Response res;

      res = unAuth
          ? await _unAuthDio.delete(
              path,
              queryParameters: parameters,
            )
          : await _dio.delete(
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

  Future<ResponseModel?> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool unAuth = false,
  }) async {
    _dio.options.headers["Authorization"] =
        "Bearer ${getx.Get.find<AuthController>().auth?.accessToken}";

    try {
      Response res;
      res = unAuth
          ? await _unAuthDio.put(
              path,
              data: data,
              queryParameters: queryParameters,
            )
          : await _dio.put(
              path,
              data: data,
              queryParameters: queryParameters,
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
