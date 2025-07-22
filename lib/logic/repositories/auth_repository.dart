// auth_repository.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:perfectum_new/logic/models/auth_model.dart';
import 'package:perfectum_new/logic/services/device_info.dart';
import 'package:perfectum_new/logic/services/storage_services/secure_storage.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({Dio? dio}) : _dio = dio ?? Dio();

  // get stored token
  Future<AuthResponse?> getStoredToken() async {
    return await SecureStorage.getAuthResponse(type: UserType.guest);
  }

  // save token to secure storage
  Future<void> saveToken(AuthResponse authResponse) async {
    await SecureStorage.saveAuthResponse(
      response: authResponse,
    );
  }

  // get guest token
  Future<AuthResponse?> getTokenFromApi() async {
    try {
      final device = await PlatformInfo.getDeviceInfoForApi();
      
      final resp = await _dio.post(
        MyApiKeys.main + MyApiKeys.getToken, 
        data: device,
      );

      return AuthResponse.fromJson(resp.data);
    } on DioException catch (e) {
      log("${e.response?.data} get token error");
      return null;
    }
  }

  Future<OtpResponse?> sendVerificationCode({required String userNumber, required AuthResponse access}) async {
    try {
      final resp = await _dio.post(
        MyApiKeys.main + MyApiKeys.sendOtp,
        options: Options(
          headers: {
            "Authorization" : "Bearer ${access.accessToken}",
          },
        ),
        data: {"msisdn" : userNumber}
      );

      return OtpResponse.fromJson(resp.data);

    } on DioException catch (e) {
      log("${e.response?.data}");
    } catch (e) {
      log("$e unhandled exeption");
    }
    return null;
  }



}