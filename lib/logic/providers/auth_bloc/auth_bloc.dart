
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfectum_new/logic/models/auth_model.dart';
import 'package:perfectum_new/logic/repositories/auth_repository.dart';
import 'package:perfectum_new/logic/services/storage_services/hive/hive_services.dart';
import 'package:perfectum_new/logic/services/storage_services/hive/root_services.dart';
import 'package:perfectum_new/logic/services/storage_services/secure_storage.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {


  AuthRepository authRepository = AuthRepository();
  HiveServices hive = RootService.hiveServices;

  AuthBloc() :  super(AuthInitial()) {

    on<AuthInitialEvent>((event, emit) async {
      try {
        // Show loading state while checking authentication
        emit(AuthLoading());

        // Handle first-time app launch
        await _handleFirstTimeLaunch();

        // Check authentication status
        final authStatus = await _checkAuthenticationStatus();
        
        // Emit appropriate state based on authentication status
        switch (authStatus) {
          case AuthStatus.authenticated:
            emit(Authenticated());
            break;
          case AuthStatus.unauthenticated:
            emit(Unauthenticated());
            break;
          case AuthStatus.needsOnboarding:
            emit(ShowOnboarding());
            break;
          case AuthStatus.error:
            emit(AuthError(message: 'Failed to initialize authentication'));
            break;
        }
      } catch (e, stackTrace) {
        // Log error for debugging
        log('Authentication initialization failed', error: e, stackTrace: stackTrace);
        emit(AuthError(message: 'An unexpected error occurred'));
      }
    });

    on<AuthSendOtp>((event, emit) async {

      emit(AuthSensOtpLoading());

      final result = await authRepository.sendVerificationCode(
        userNumber: event.phoneNumber,
      );

      return result != null 
        ? emit(AuthSendOtpSuccess(
          userNumber: result.data.phoneNumber,
        )) 
        : emit(AuthSendOtpError(
          message: "Failed to send OTP",
        ));
    },);

    on<AuthVerfyOtp>((event, emit) async {

      emit(AuthVerfyOtpLoading());

      final result = await authRepository.verifyOtp(
        userPhone: event.userPhone,
        code: event.code,
      );

      result  ? emit(AuthVerfyOtpSuccess(
          userNumber: event.userPhone,
        )) 
      : emit(AuthVerfyOtpError(
          message: "Failed to verify OTP",
        ));

      log("AuthVerfyOtp userPhone: ${event.userPhone} and code: ${event.code} result: $result");

    },);

  }

  Future<void> _handleFirstTimeLaunch() async {
    final isFirstTime = hive.isFirstTime();
    
    if (isFirstTime) {
      // Clear all stored credentials for fresh start
      await SecureStorage.clear();
      await hive.setFirstTime();
    }
  }

  Future<AuthStatus> _checkAuthenticationStatus() async {
    // First, check if user has a PIN set up
    final userPin = await SecureStorage.getUserPin();
    
    if (userPin != null) {
      // User has PIN, they're authenticated
      return AuthStatus.authenticated;
    }
    
    // No PIN, check for existing auth tokens
    final existingAuthResponse = await SecureStorage.getAuthResponse(
      type: UserType.guest,
    );
    
    log('Existing refresh token: ${existingAuthResponse?.refreshToken}');
    
    if (existingAuthResponse != null) {
      // Has existing tokens, user needs to set up PIN
      return AuthStatus.unauthenticated;
    }
    
    // No existing tokens, try to get new guest tokens
    final newAuthResponse = await _fetchAndSaveGuestTokens();
    
    if (newAuthResponse == null) {
      // Failed to get tokens
      return AuthStatus.error;
    }
    
    // Successfully got guest tokens, show onboarding
    return AuthStatus.needsOnboarding;
  }

  // Helper method to fetch and save guest tokens
  Future<AuthResponse?> _fetchAndSaveGuestTokens() async {
    try {
      final authResponse = await AuthRepository.getTokenFromApi();
      
      if (authResponse != null) {
        await SecureStorage.saveAuthResponse(
          response: authResponse,
        );
        return authResponse;
      }
      
      return null;
    } catch (e) {
      log('Failed to fetch guest tokens', error: e);
      return null;
    }
  }

}


enum AuthStatus {
  authenticated,
  unauthenticated,
  needsOnboarding,
  error,
}