part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
class AuthError extends AuthState {
  final String? message;

  AuthError({this.message});
}

class Authenticated extends AuthState {}
class Unauthenticated extends AuthState {}
class ShowOnboarding extends AuthState {}


class AuthSensOtpLoading extends AuthState {}
class AuthSendOtpSuccess extends AuthState {
  final String userNumber;

  AuthSendOtpSuccess({required this.userNumber});
}
class AuthSendOtpError extends AuthState {
  final String? message;

  AuthSendOtpError({this.message});
}


class AuthVerfyOtpLoading extends AuthState {}
class AuthVerfyOtpSuccess extends AuthState {
  final String userNumber;
  AuthVerfyOtpSuccess({required this.userNumber});
}
class AuthVerfyOtpError extends AuthState {
  final String? message;      
  AuthVerfyOtpError({this.message});
}