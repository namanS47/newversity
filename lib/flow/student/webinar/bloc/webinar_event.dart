part of 'webinar_bloc.dart';

@immutable
abstract class WebinarEvent {}

class FetchWebinarListEvent extends WebinarEvent {}

class RegisterForWebinarEvent extends WebinarEvent {
  RegisterForWebinarEvent({required this.webinarId});
  final String webinarId;
}
