part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class InitialState extends LoginState {}

class VerifyOtpLoadingState extends InitialState {}

class VerifyOtpSuccessState extends InitialState {}

class VerifyOtpFailureState extends InitialState {}
