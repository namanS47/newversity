part of 'webinar_bloc.dart';

@immutable
abstract class WebinarState {}

class WebinarInitial extends WebinarState {}

class FetchWebinarListLoadingState extends WebinarState{}

class FetchWebinarListSuccessState extends WebinarState{
  FetchWebinarListSuccessState({required this.webinarList});
  final List<WebinarDetailsResponseModel> webinarList;
}

class FetchWebinarListFailureState extends WebinarState{
  FetchWebinarListFailureState({required this.message});
  final String message;
}

class RegisterForWebinarLoadingState extends WebinarState {
  RegisterForWebinarLoadingState({required this.webinarId});
  final String webinarId;
}

class RegisterForWebinarSuccessState extends WebinarState {
  RegisterForWebinarSuccessState({required this.webinarId});
  final String webinarId;
}

class RegisterForWebinarFailureState extends WebinarState {}
