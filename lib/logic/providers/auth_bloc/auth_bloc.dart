
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfectum_new/logic/models/auth_model.dart';
import 'package:perfectum_new/logic/repositories/auth_repository.dart';
import 'package:perfectum_new/logic/services/storage_services/secure_storage.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {


  AuthRepository authRepository = AuthRepository();

  AuthBloc() :  super(AuthInitial()) {

    on<AuthInitialEvent>((event, emit) async {
      emit(AuthLoading());
      final userPin = await SecureStorage.getUserPin();
      if(userPin != null) {
        return emit(Authenticated());
      } else {
        final userAccessKeys = await SecureStorage.getAuthResponse(type: UserType.guest);

        if(userAccessKeys == null) {
          final userAccessKeys = await authRepository.getTokenFromApi();
          if(userAccessKeys != null) {
            await SecureStorage.saveAuthResponse(
              response: userAccessKeys,
            );
          } else {
            emit(AuthError());
          }
          return emit(ShowOnboarding());
        }

        return emit(Unauthenticated());
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

    on<AuthVerfyOtp>((event, emit) {
      // emit(Auth)
    },);

  }



}

