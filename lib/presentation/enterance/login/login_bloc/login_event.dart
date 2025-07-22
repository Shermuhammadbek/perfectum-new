part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginDeleteAccaunt extends LoginEvent {}

class LoginGetVerificationCode extends LoginEvent{
  final String phone;
  final BuildContext context;
  final bool isResend;

  LoginGetVerificationCode({
    required this.phone, required this.context,
    this.isResend = false,
  });
}

class LoginResendVerificationCode extends LoginEvent {
  final BuildContext context;

  LoginResendVerificationCode({required this.context});
}

class LoginVerifyCode extends LoginEvent {
  final String otp;
  final BuildContext context;

  LoginVerifyCode({
    required this.otp, required this.context
  });
}



class LoginRepairPinField extends LoginEvent {}

class LoginPasswordTyping extends LoginEvent {
  final int index;

  LoginPasswordTyping({required this.index});
}

class LoginCheckEsim extends LoginEvent {}

class LoginChangePasswordState extends LoginEvent {
  final DevicePasswordEnum devicePasswordEnum;
  bool isFirstTime;

  LoginChangePasswordState({
    required this.devicePasswordEnum, this.isFirstTime = false,
  });
}

class LoginCreateNewPassword extends LoginEvent {
  final String password;

  LoginCreateNewPassword({required this.password});
}

class LoginCheckNewPassword extends LoginEvent {
  final String password;

  LoginCheckNewPassword({required this.password,});
}

class LoginCheckPassword extends LoginEvent {
  final String password;

  LoginCheckPassword({required this.password});
}

class LoginClearAll extends LoginEvent {}

class LoginUnlockWithBiometrics extends LoginEvent {}