part of 'student_feedback_bloc.dart';

@immutable
abstract class StudentFeedbackState {}

class StudentFeedbackInitial extends StudentFeedbackState {}

class SaveStudentFeedbackLoadingState extends StudentFeedbackState {}

class SaveStudentFeedbackSuccessState extends StudentFeedbackState {
  SaveStudentFeedbackSuccessState({required this.shouldPopScreen});
  final bool shouldPopScreen;
}

class SaveStudentFeedbackFailureState extends StudentFeedbackState {
  SaveStudentFeedbackFailureState({required this.errorMessage});
  final String errorMessage;
}
