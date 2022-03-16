import 'dart:typed_data';
import 'package:dio/dio.dart';

import '../helpers/http_response.dart';
import '../models/user.dart';
import '../data/authentication_client.dart';
import '../helpers/http.dart';

class AccountAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;

  AccountAPI(this._http, this._authenticationClient);

  Future<HttpResponse<User>> getUserInfo() async {
    final token = await _authenticationClient.accessToken;

    return _http.response<User>('/api/v1/user-info',
      method: 'GET',
      headers: {'content-type': 'application/json', 'token': token!},
      parser: (data) => User.fromJson(data));
  }

  Future<String> updateAvatar(Uint8List bytes, String fileName) async {
    final token = await _authenticationClient.accessToken;

    final response = await _http.response<String>('/api/v1/update-avatar',
        method: 'POST',
        headers: {
          'token': token!
        },
        formData: {
          'attachment': MultipartFile.fromBytes(bytes, filename: fileName)
        });

    return response.data!;
  }
}
