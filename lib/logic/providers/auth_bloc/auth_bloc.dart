import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfectum_new/logic/models/auth_model.dart';
import 'package:perfectum_new/logic/repositories/auth_repository.dart';
import 'package:perfectum_new/logic/services/storage_services/secure_storage.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  Dio dio = Dio();
  AuthRepository authRepository = AuthRepository();
  AuthResponse? userAccessKeys;

  AuthBloc() : super(AuthInitial()) {
    on<AuthInitialEvent>((event, emit) async {

      emit(AuthLoading());

      final userAccessKeys = await SecureStorage.getAuthResponse(type: UserType.guest);

      if(userAccessKeys == null) {
        final userAccessKeys = await authRepository.getTokenFromApi();
        log("${userAccessKeys?.refreshToken} refresh token from api");
        if(userAccessKeys != null) {
          await SecureStorage.saveAuthResponse(
            response: userAccessKeys,
          );
        } else {
          
        }
      }
      return emit(AuthNavigateToLogin());
    });
  }



}

