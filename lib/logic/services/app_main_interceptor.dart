
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:perfectum_new/logic/models/auth_model.dart';
import 'package:perfectum_new/logic/providers/auth_bloc/auth_bloc.dart';
import 'package:perfectum_new/logic/repositories/auth_repository.dart';
import 'package:perfectum_new/logic/services/storage_services/secure_storage.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

class AppMainInterceptor extends Interceptor {
  final Dio dio;
  
  AppMainInterceptor({required this.dio});
  
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
    log("onError: ${err.message} for ${err.requestOptions.path}");
    if (err.response?.statusCode == 401) {

      bool refreshSuccess = false;

      final userAccess = await SecureStorage.getAuthResponse(type: UserType.user);

      if(userAccess != null) {
        refreshSuccess = await _refreshToken(type: UserType.guest);
      } else {
        refreshSuccess = await getGuestToken();
      }

      if (refreshSuccess) {
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
  
  Future<bool> getGuestToken() async {
    try {
      final response = await AuthRepository.getTokenFromApi();
      if(response != null) {
        await SecureStorage.saveAuthResponse(response: response);
      }

      return true;
    } catch (e) {
      log("Get guest token $e");
    }
    return false;
  }

  Future<bool> _refreshToken({required UserType type}) async {
    log("_refreshToken called for type: $type");
    try {
      final refreshToken = await SecureStorage.getAuthResponse(type: type);
      log("Refresh token: ${refreshToken?.refreshToken}");
      log("Access token: ${refreshToken?.accessToken}");
      if (refreshToken == null) return false;
      
      final response = await dio.post(
        MyApiKeys.refreshToken,
        options: Options(
          headers: {
            "Authorization": "Bearer ${refreshToken.accessToken}",
          },
        ),
        data: {'refresh_token': refreshToken.refreshToken},
      );

      log("${response.statusCode} - ${response.data}");
      
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        await SecureStorage.saveAuthResponse(
          response: authResponse,
        );
        return true;
      }
      
       
    } on DioException catch (e) {
      log("DioException during token refresh: ${e.response?.data}");

    } catch (e) {
      log("Error refreshing token: $e");
    }

    return false;
  }
  
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    log("_retry called for ${requestOptions.path}");
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
    log("_handleAuthFailure called");
    SecureStorage.clear();
    getx.Get.offAllNamed('/login');
    
    // Auth Bloc ga logout event yuborish
    final context = getx.Get.context;
    if (context != null) {
      context.read<AuthBloc>().add(LogoutEvent());
    }
  }
}