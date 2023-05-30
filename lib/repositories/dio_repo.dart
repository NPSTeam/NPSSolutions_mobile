import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as getx;
import 'package:npssolutions_mobile/configs/app_key.dart';
import 'package:npssolutions_mobile/models/response_model.dart';

import '../controllers/auth_controller.dart';

class DioRepo {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppKey.BACKEND_URL));

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
          options.headers['Authorization'] =
              'Bearer ${getx.Get.find<AuthController>().auth?.accessToken}';

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
          debugPrint("Status Code: ${e.response?.statusCode}");
          debugPrint("Error Response: ${e.response}");
          RequestOptions origin = e.requestOptions;

          if (e.response?.statusCode == 401) {
            try {
              Response<dynamic> data = await Dio(BaseOptions(
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
              );

              if (data.statusCode == 200) {
                debugPrint("Refresh token successfully - ${data.data}");
                debugPrint(
                    "NEW ACCESS TOKEN - ${data.data['data']['access_token']}");
                debugPrint(
                    "NEW REFRESH TOKEN - ${data.data['data']['refresh_token']}");

                if (data.data['data']['access_token'] != null &&
                    data.data['data']['access_token'] != '' &&
                    data.data['data']['refresh_token'] != null &&
                    data.data['data']['refresh_token'] != '') {
                  await getx.Get.find<AuthController>().updateTokenToLocal(
                      accessToken: data.data['data']['access_token'],
                      refreshToken: data.data['data']['refresh_token']);

                  origin.headers['Authorization'] =
                      "Bearer ${data.data['data']['access_token']}";

                  final opts = Options(
                      method: e.requestOptions.method,
                      headers: e.requestOptions.headers);
                  final cloneReq = await _dio.request(e.requestOptions.path,
                      options: opts,
                      data: e.requestOptions.data,
                      queryParameters: e.requestOptions.queryParameters);

                  return handler.resolve(cloneReq);
                } else if (data.statusCode == 401) {
                  await getx.Get.find<AuthController>().logout();
                  return;
                }
              }
            } catch (err) {
              debugPrint(err.toString());

              await getx.Get.find<AuthController>().logout();

              return;
            }
          }

          if (EasyLoading.isShow) {
            await EasyLoading.dismiss();
          }
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
