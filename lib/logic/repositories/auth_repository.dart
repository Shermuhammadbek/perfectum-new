// auth_repository.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:perfectum_new/logic/models/auth_model.dart';
import 'package:perfectum_new/logic/services/app_api_services.dart';
import 'package:perfectum_new/logic/services/device_info.dart';
import 'package:perfectum_new/logic/services/storage_services/secure_storage.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

class AuthRepository extends AppApiServices {

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
      
      final resp = await Dio().post(
        MyApiKeys.main + MyApiKeys.getToken, 
        data: device,
      );

      return AuthResponse.fromJson(resp.data);
    } on DioException catch (e) {
      log("${e.response?.data} get token error");
      return null;
    }
  }

  Future<OtpResponse?> sendVerificationCode({required String userNumber}) async {
    log("${appDio.options.headers} sendVerificationCode called");
    try {
      final resp = await appDio.post(
        MyApiKeys.sendOtp,
        data: {"msisdn" : userNumber}
      );

      log("sendVerificationCode response: ${resp.realUri}");

      return OtpResponse.fromJson(resp.data);

    } on DioException catch (e) {
      log("${e.response?.data}");
    } catch (e) {
      log("$e unhandled exeption");
    }
    return null;
  }

  Future<bool> verifyOtp({required String userPhone, required String otp}) async {
    try {
      final resp = await appDio.post(
        MyApiKeys.verifyOtp,
        data: {
          "msisdn": userPhone,
          "otp": otp,
        }
      );

      log("verifyOtp response: ${resp.data}");

      return true;

    } on DioException catch (e) {
      log("DioException during verifyOtp: ${e.response?.data}");
    } catch (e) {
      log("Unhandled exception during verifyOtp: $e");  
    }

    return false;
  }



}