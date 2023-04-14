part of 'student_previous_session_bloc.dart';


@immutable
abstract class StudentPreviousSessionEvents {}

class FetchStudentPreviousSessionEvent extends StudentPreviousSessionEvents{
  final String sessionType;
  FetchStudentPreviousSessionEvent({required this.sessionType});
}