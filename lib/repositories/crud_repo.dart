import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nps_social/configs/app_key.dart';

class CrudRepository {
  final _dio = Dio(BaseOptions(
    baseUrl: AppKey.BACKEND_URL ?? '',
  ));

  Future<Response?> get(String path, {Map<String, dynamic>? parameters}) async {
    try {
      Response res;
      res = await _dio.get(path, queryParameters: parameters);
      return res;
    } on DioError catch (e) {
      // print(e.response);
      if (e.response != null) {
        print(e.response?.data);
      } else {
        print(e.message);
      }
    }

    return null;
  }

  Future post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      Response res;
      res = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    }

    return null;
  }
}
