part of 'login_bloc.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}


// code sending ...
class LoginVerificationCodeLoading extends LoginState {}
class LoginVerificationCodeSended extends LoginState {
  final String userNumber;

  LoginVerificationCodeSended({required this.userNumber});  
}
class LoginVerificationCodeSendingError extends LoginState {}

class LoginCodeVeryfying extends LoginState {}
class LoginCodeVeryfyed extends LoginState {}
class LoginCodeVeryfyError extends LoginState {}

class LoginCodePinFieldRepaired extends LoginState {}
class LoginCodeNotSame extends LoginState {}

class LoginTypingEnded extends LoginState {
  final List<bool> indicator;
  final List<int> password;

  LoginTypingEnded({
    required this.indicator, required this.password,
  });
}

class LoginPasswordStateChanged extends LoginState {
  final DevicePasswordEnum devicePasswordEnum;

  LoginPasswordStateChanged({required this.devicePasswordEnum});
}
class LoginReadyToEnter extends LoginState {}
class LoginPasswordError extends LoginState {}
class LoginPasswordNotSame extends LoginState {}

class LoginAllThinksReady extends LoginState {}

class LoginNavigateToHome extends LoginState {}

class LoginDecreaseAttempt extends LoginState {
  final int attemps;
  LoginDecreaseAttempt({required this.attemps});
}
class LoginAttempsEnded extends LoginState {}

//? Esim Check
class LoginEsimChecking extends LoginState {}
class LoginEsimUnavailable extends LoginState {}
class LoginEsimAvailable extends LoginState {}