
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:perfectum_new/logic/models/auth_model.dart';
import 'package:perfectum_new/logic/providers/auth_bloc/auth_bloc.dart';
import 'package:perfectum_new/logic/services/storage_services/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  
  AuthInterceptor({required this.dio});
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    log("onRequest: ${options.method} ${options.path}");
    final authResponse = await SecureStorage.getAuthResponse(type: UserType.guest);
    if (authResponse != null) {
      options.headers['Authorization'] = 'Bearer ${authResponse.accessToken}';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/')) {
      // Token refresh qilish
      final refreshSuccess = await _refreshToken(type: UserType.guest);
      
      if (refreshSuccess) {
        // Qayta urinish
        try {
          final response = await _retry(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          _handleAuthFailure();
        }
      } else {
        _handleAuthFailure();
      }
    }
    
    handler.next(err);
  }
  
  Future<bool> _refreshToken({required UserType type}) async {
    try {
      final refreshToken = await SecureStorage.getAuthResponse(type: type);
      if (refreshToken == null) return false;
      
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken.refreshToken},
      );
      
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        await SecureStorage.saveAuthResponse(
          response: authResponse,
        );
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final result = await SecureStorage.getAuthResponse(type: UserType.guest);
    
    if(result != null) {
      final options = Options(
        method: requestOptions.method,
        headers: {
          ...requestOptions.headers,
          'Authorization': 'Bearer ${result.accessToken}',
        },
      );

      return dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
    } else {
      throw Exception("No valid auth token found");
    }
    
    
  }
  
  void _handleAuthFailure() {
    // Logout qilish va login sahifasiga yo'naltirish
    SecureStorage.clear();
    getx.Get.offAllNamed('/login');
    
    // Auth Bloc ga logout event yuborish
    final context = getx.Get.context;
    if (context != null) {
      context.read<AuthBloc>().add(LogoutEvent());
    }
  }
}