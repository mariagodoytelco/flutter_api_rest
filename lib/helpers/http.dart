import 'package:dio/dio.dart';

import '../utils/logs.dart';
import 'http_response.dart';

class Http {
  late Dio _dio;
  //late bool _logsEnabled;

  Http({required dio, required logsEnabled}) {
    _dio = dio;
    //_logsEnabled = logsEnabled;
  }

  Future<HttpResponse<T>> response<T>(String path,
      {String method = 'GET',
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      Map<String, dynamic>? formData,
      Map<String, String>? headers,
      T Function(dynamic data)? parser}) async {
    try {
      //await Future.delayed(const Duration(seconds: 2));
      final response = await _dio.request(path,
          options: Options(method: method, headers: headers),
          queryParameters: queryParameters,
          data: formData != null ? FormData.fromMap(formData) : data);
      Logs.p.i(response.data);

      if (parser != null) {
        return HttpResponse.success<T>(parser(response.data));
      }

      return HttpResponse.success<T>(response.data);
    } on Exception catch (e) {
      Logs.p.e(e);

      int statusCode = 0;
      String message = "unknow error";
      dynamic data;

      if (e is DioError) {
        //int statusCode = -1;
        message = e.message;
        if (e.response != null) {
          statusCode = e.response!.statusCode!;
          message = e.response!.statusMessage!;
          data = e.response!.data;
        }
      }
      return HttpResponse.fail<T>(
          statusCode: statusCode, message: message, data: data);
    }
  }
}
