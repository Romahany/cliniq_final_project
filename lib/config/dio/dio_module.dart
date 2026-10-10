import 'package:dio/dio.dart';

import 'package:injectable/injectable.dart';

import 'auth_interceptor.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(AuthInterceptors());
    return dio;
  }
}
