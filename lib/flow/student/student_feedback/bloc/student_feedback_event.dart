part of 'student_feedback_bloc.dart';

@immutable
abstract class StudentFeedbackEvent {}

class SaveStudentFeedbackEvent extends StudentFeedbackEvent {
  SaveStudentFeedbackEvent(
      {required this.sessionSaveRequest, required this.forRating});

  final SessionSaveRequest sessionSaveRequest;
  final bool forRating;
}
