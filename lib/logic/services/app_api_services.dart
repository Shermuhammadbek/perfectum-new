import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:perfectum_new/logic/repositories/auth_interceptor.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

class AppApiServices {
  late final Dio appDio;
  late final Dio _appAuthDio;

  AppApiServices() {
    initApiInterceptors();
  }

  void initApiInterceptors() {
    log("AppApiServices initApiInterceptors called");
    final baseOptions = BaseOptions(
      baseUrl: MyApiKeys.main,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    appDio = Dio(baseOptions);
    _appAuthDio = Dio(baseOptions);

    appDio.interceptors.addAll([
      AuthInterceptor(dio: _appAuthDio),
      getLogInterceptor()
    ]);
  }

  LogInterceptor getLogInterceptor() {
    return LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (text) => log('API LOG: $log'),
    );
  }



}