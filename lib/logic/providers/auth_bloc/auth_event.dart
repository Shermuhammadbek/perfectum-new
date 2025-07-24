part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {
  final String? message;

  LogoutEvent({this.message});
}

class AuthSendOtp extends AuthEvent {
  final String phoneNumber;

  AuthSendOtp({required this.phoneNumber});
}

class AuthVerfyOtp extends AuthEvent {
  final String userPhone;
  final String code;

  AuthVerfyOtp({
    required this.code, required this.userPhone,
  });
}