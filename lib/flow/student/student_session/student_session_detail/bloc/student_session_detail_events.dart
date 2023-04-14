part of 'student_session_detail_bloc.dart';

@immutable
abstract class StudentSessionDetailEvents {}

class FetchStudentSessionDetailEvent extends StudentSessionDetailEvents {
  final String sessionId;
  FetchStudentSessionDetailEvent({required this.sessionId});
}

class SaveStudentRatingForSessionEvent extends StudentSessionDetailEvents{
  final SessionSaveRequest sessionSaveRequest;
  SaveStudentRatingForSessionEvent({required this.sessionSaveRequest});
}

class SaveStudentReviewForSessionEvent extends StudentSessionDetailEvents {
  final SessionSaveRequest sessionSaveRequest;
  SaveStudentReviewForSessionEvent({required this.sessionSaveRequest});
}
