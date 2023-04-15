part of 'student_session_detail_bloc.dart';

@immutable
abstract class StudentSessionDetailStates {}

class StudentSessionDetailInitialState extends StudentSessionDetailStates {}

class FetchingStudentSessionDetailState extends StudentSessionDetailStates {}

class FetchedStudentSessionDetailState extends StudentSessionDetailStates {
  final SessionDetailResponseModel sessionDetailResponseModel;
  FetchedStudentSessionDetailState({required this.sessionDetailResponseModel});
}

class FetchingStudentSessionDetailFailureState
    extends StudentSessionDetailStates {
  final String msg;
  FetchingStudentSessionDetailFailureState({required this.msg});
}

class SavingStudentRatingState extends StudentSessionDetailStates {}

class SavedStudentRatingState extends StudentSessionDetailStates {}

class SavingStudentRatingFailureState extends StudentSessionDetailStates {
  final String? message;
  SavingStudentRatingFailureState({required this.message});
}

class SavingStudentReviewState extends StudentSessionDetailStates {}

class SavedStudentReviewState extends StudentSessionDetailStates {}

class SavingStudentReviewFailureState extends StudentSessionDetailStates {
  final String? message;
  SavingStudentReviewFailureState({required this.message});
}
