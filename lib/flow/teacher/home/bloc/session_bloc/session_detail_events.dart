part of 'session_details_bloc.dart';

@immutable
abstract class SessionDetailEvents {}

class FetchSessionDetailEvent extends SessionDetailEvents {
  final String type;
  FetchSessionDetailEvent({required this.type});
}

class FetchStudentDetailsEvent extends SessionDetailEvents {
  final String studentId;
  FetchStudentDetailsEvent({required this.studentId});
}

class SessionAddingEvent extends SessionDetailEvents {
  final SessionSaveRequest sessionSaveRequest;
  SessionAddingEvent({required this.sessionSaveRequest});
}
