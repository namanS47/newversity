part of 'session_details_bloc.dart';

@immutable
abstract class SessionDetailsEvents {}

class CancelRequestSelectEvent extends SessionDetailsEvents {
  String item;
  CancelRequestSelectEvent({required this.item});
}

class FetchSessionDetailByIdEvent extends SessionDetailsEvents {
  final String id;
  FetchSessionDetailByIdEvent({required this.id});
}

class SessionAddingEvent extends SessionDetailsEvents {
  final SessionSaveRequest sessionSaveRequest;
  SessionAddingEvent({required this.sessionSaveRequest});
}
