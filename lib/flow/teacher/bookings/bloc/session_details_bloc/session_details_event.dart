part of 'session_details_bloc.dart';

@immutable
abstract class SessionDetailsEvents {}

class CancelRequestSelectEvent extends SessionDetailsEvents {
  String item;
  CancelRequestSelectEvent({required this.item});
}


