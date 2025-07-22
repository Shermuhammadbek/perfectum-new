part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {
  final String? message;

  LogoutEvent({this.message});
}