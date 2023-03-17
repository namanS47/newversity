part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

// class
class VerifyOtpEvent extends LoginEvent {
  VerifyOtpEvent({required this.loginArguments});
  final LoginArguments loginArguments;
}