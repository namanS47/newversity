part of 'webinar_bloc.dart';

@immutable
abstract class WebinarEvent {}

class FetchWebinarListEvent extends WebinarEvent {}

class RegisterForWebinarEvent extends WebinarEvent {
  RegisterForWebinarEvent({required this.webinarId, required this.agenda});
  final String webinarId;
  final String agenda;
}
