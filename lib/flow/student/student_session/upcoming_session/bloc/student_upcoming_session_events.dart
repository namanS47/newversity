part of 'student_upcoming_session_bloc.dart';

@immutable
abstract class StudentUpcomingSessionEvents {}

class FetchStudentUpcomingSessionEvent extends StudentUpcomingSessionEvents {
  final String sessionType;
  FetchStudentUpcomingSessionEvent({required this.sessionType});
}
