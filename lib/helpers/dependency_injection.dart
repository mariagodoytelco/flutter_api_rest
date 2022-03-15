import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/account_api.dart';
import '../data/authentication_client.dart';
import '../api/authentication_api.dart';
import 'http.dart';

abstract class DependencyInjection {
  static void initialization() {
    final Dio dio =
        Dio(BaseOptions(baseUrl: 'https://curso-api-flutter.herokuapp.com'));

    Http http = Http(dio: dio, logsEnabled: true);

    const FlutterSecureStorage secureStorage = FlutterSecureStorage();

    final AuthenticationAPI authenticationAPI = AuthenticationAPI(http);
    final AuthenticationClient authenticationClient = AuthenticationClient(secureStorage, authenticationAPI);
    final AccountAPI accountAPI = AccountAPI(http, authenticationClient);

    GetIt.instance.registerSingleton<AccountAPI>(accountAPI);
    GetIt.instance.registerSingleton<AuthenticationAPI>(authenticationAPI);
    GetIt.instance.registerSingleton<AuthenticationClient>(authenticationClient);

  }
}
