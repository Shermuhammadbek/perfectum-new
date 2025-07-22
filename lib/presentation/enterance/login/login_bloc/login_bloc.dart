
import 'dart:developer';
import 'package:perfectum_new/logic/providers/main_bloc/main_bloc.dart';
import 'package:perfectum_new/logic/providers/home_bloc/home_page_bloc.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esim/flutter_esim.dart';
import 'package:get/get.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/services/storage_services/hive/hive_services.dart';
import '../../../../logic/services/storage_services/hive/root_services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LogInBloc extends Bloc<LoginEvent, LoginState> {

  final List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0];
  final dio = Dio();
  final HomePageBloc homePageBloc;
  final MainBloc mainBloc;
  final HiveServices hive = RootService.hiveServices;
  final int passwordLength = 4;
  late String userPhone;
  late String contactPhone;
  bool isFirstTime = false;

  late List<bool> indicator;
  List<int> password = [];
  String passwordString = "";
  int attemps = 4;

  DevicePasswordEnum devicePasswordEnum = DevicePasswordEnum.enterExistingPassword;

  LogInBloc({
    required this.homePageBloc, required this.mainBloc
    }) : super(LoginInitial()) {
    indicator = List.filled(passwordLength, false);

    on<LoginPasswordTyping>((event, emit) async {
      fillPassword(event, emit, index: event.index);
      emit(LoginTypingEnded(
        indicator: indicator, password: password,
      ));
    },);

    on<LoginChangePasswordState>((event, emit) {
      isFirstTime = event.isFirstTime;

      devicePasswordEnum = event.devicePasswordEnum;
      emit(LoginPasswordStateChanged(
        devicePasswordEnum: event.devicePasswordEnum),
      );
    },);

    on<LoginCreateNewPassword>((event, emit) {
      passwordString = event.password;
      indicator = List.generate(passwordLength, (index){return false;});
      password = [];
      add(LoginChangePasswordState(
        devicePasswordEnum: DevicePasswordEnum.confirmPassword,
      ),);
    },);

    on<LoginCheckNewPassword>((event, emit) async {
      if(event.password == passwordString){
        await hive.setPassword(event.password);
        emit(LoginReadyToEnter());
        await Future.delayed(const Duration(milliseconds: 2000), (){
          log("all thinks ready");
          emit(LoginAllThinksReady());
        });
      } else {
        emit(LoginPasswordNotSame());
      }
    },);

    on<LoginRepairPinField>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(LoginCodePinFieldRepaired());
    },);

    on<LoginCheckPassword>((event, emit) async {
      final result = hive.getPassword();
      log("old password: $result");
      bool isCorrect = result == event.password;
      bool isReset = devicePasswordEnum == DevicePasswordEnum.resetPassword;
      bool isExisting = devicePasswordEnum == DevicePasswordEnum.enterExistingPassword;

      if(isCorrect){
        if(isReset){
          add(LoginClearAll());
          add(LoginChangePasswordState(
            devicePasswordEnum: DevicePasswordEnum.createPassword,
          ));
        }
        isExisting ? emit(LoginNavigateToHome()) : emit(LoginPasswordError());

      } else {
        emit(LoginPasswordError()); add(LoginClearAll());
        
        await Future.delayed(const Duration(milliseconds: 300), () {
          log("future worked");
          emit(LoginPasswordStateChanged(
            devicePasswordEnum: isExisting 
              ? DevicePasswordEnum.enterExistingPassword 
              : DevicePasswordEnum.resetPassword,
          ));
        });

        if(isExisting){
          attemps > 1 ? attemps - 1 : emit(LoginAttempsEnded());
          return emit(LoginDecreaseAttempt(attemps: attemps));
        }

        if(isReset){
          emit(LoginAttempsEnded());
        }

      }
    },);

    on<LoginClearAll>((event, emit) {
      log("clear all");
      indicator = List.filled(passwordLength, false);
      password.clear();
    },);

    on<LoginResendVerificationCode>((event, emit) async {
      add(LoginGetVerificationCode(
        phone: userPhone, context: event.context,
        isResend: true,
      ),);
    },);

    on<LoginGetVerificationCode>((event, emit) async {
      if(event.isResend) {
        final result = await sendVerificationCode(event, emit);
        if(!result) {
          emit(LoginVerificationCodeSendingError());
        }
      } else {
        emit(LoginVerificationCodeLoading());

        await Future.delayed(const Duration(seconds: 2),);

        final result = await sendVerificationCode(event, emit);
        result 
          ? emit(LoginVerificationCodeSended(userNumber: contactPhone))
          : emit(LoginVerificationCodeSendingError());
      }
    },);

    on<LoginVerifyCode>((event, emit) async {
      emit(LoginCodeVeryfying());
      bool result = await veryfyOtp(event, emit);

      if(result) {
        await hive.setUserMainNumer(userPhone);
        emit(LoginCodeVeryfyed());
      } else {
        emit(LoginCodeVeryfyError());
      }

    },);

    on<LoginCheckEsim>((event, emit) async {
      emit(LoginEsimChecking());
      await Future.delayed(const Duration(milliseconds: 600),);
      bool isAvailable = await FlutterEsim().isSupportESim(["all"]);
      isAvailable ? emit(LoginEsimAvailable()) : emit(LoginEsimUnavailable());
    },);

  }

  Future<bool> sendVerificationCode(LoginGetVerificationCode event, Emitter<LoginState> emit) async {
    userPhone = event.phone;
    try {
      final resp = await dio.post(
        options: Options(headers: homePageBloc.headerToken()),
        MyApiKeys.main + MyApiKeys.sendOtp,
        data: {
          "msisdn" : event.phone
        }
      );
      log("${resp.data} response");
      log("${resp.statusCode} status code");
      contactPhone = resp.data["data"]["msisdn"];
      return (resp.statusCode ?? 400) <= 200;

    } on DioException catch (e) {
      if(event.context.mounted){
        errorHandling(e: e, label: "Send verification code", ctx: event.context);
      }
      } catch (e) {
      log("$e unhandled exeption");
    }
    return false;
  }

  Future<bool> veryfyOtp(LoginVerifyCode event, Emitter<LoginState> emit) async {
    log("veryfy otp worked");
    try {
      final resp = await dio.post(
        options: Options(headers: homePageBloc.headerToken()),
        MyApiKeys.main + MyApiKeys.verifyOtp,
        data: {
          "msisdn" : userPhone,
          "otp" : event.otp
        }
      );

      log("${resp.data} verify otp response");
      log("${resp.statusCode} status code");

      final resultToken = resp.data["access_token"];

      log("$resultToken ");

      hive.setUserToken(resultToken);
      mainBloc.userToken = resultToken;

      return (resp.statusCode ?? 400) <= 200;

    } on DioException catch (e) {
      if(event.context.mounted){
        errorHandling(e: e, label: "veryfy otp", ctx: event.context);
      }
    } catch (e) {
      log("$e unhandled exeption");
    }
    return false;
  }
  

  void fillPassword(LoginPasswordTyping event, Emitter<LoginState> emit, {required int index}){
    final int n = numbers.length;

    if(index == (n - 3)){
      add(LoginUnlockWithBiometrics());
    }
    if(password.isNotEmpty && index == (n - 1)){
      final last = password.length - 1;
      password.removeAt(last);
      indicator[last] = false;
    }
    if(password.length < passwordLength && index != (n - 1) && index != (n - 3)){
      password.add(numbers[index]);
    }
    for (var i = 0; i < passwordLength; i++) {
      if (password.isEmpty) {
        indicator = List.filled(passwordLength, false);
      }
      if ((i + 1) <= password.length) {
        indicator[i] = true;
      }
    }
    if(password.length == passwordLength){
      log("password: $password");
      switch (devicePasswordEnum) {
        case DevicePasswordEnum.createPassword:
          return add(LoginCreateNewPassword(password: password.toString()));
        case DevicePasswordEnum.confirmPassword:
          return add(LoginCheckNewPassword(password: password.toString()));
        case DevicePasswordEnum.enterExistingPassword:
          return add(LoginCheckPassword(password: password.toString()));
        case DevicePasswordEnum.resetPassword:
          return add(LoginCheckPassword(password: password.toString()));
      }
    }
  }
}


enum DevicePasswordEnum {
  enterExistingPassword(
    name: "Enter passwod",
  ), 
  createPassword(
    name: "Создать пароль",
  ),
  confirmPassword(
    name: "Подтвердите пароль",
  ),
  resetPassword(
    name: "Enter the password in use.",
  );

  final String name;

  const DevicePasswordEnum({
    required this.name, 
  });
}



void errorHandling({required DioException e, String? label, BuildContext? ctx}) {
  log("$e eror handling worked");
  if(label != null){
    log("${e.error}: status error => $label");
    log("${e.message}: message => $label");
    log("${e.response?.statusCode}: status code => $label");
    log("${e.response?.statusMessage}: status message => $label");
    log("${e.response?.data}: status data => $label");
    log("${e.response?.realUri}: status real uri => $label");
  }
  if(ctx != null){
    if(e.response?.statusCode == 404){
      Get.snackbar(
        "", "Server error, try later!",
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        borderRadius: 10,
        titleText: const Text(
          "Error",
          style: TextStyle(
            color: Color(0xffe50101),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: (snack) {
          Get.back();
        },
      );
    }
  }
}