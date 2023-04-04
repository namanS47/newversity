part of 'session_details_bloc.dart';

@immutable
abstract class SessionStates {}

class SessionDetailInitialState extends SessionStates {}

class FetchingSessionDetailState extends SessionDetailInitialState {}

class FetchedSessionDetailState extends SessionStates {
  final List<SessionDetailsResponse>? sessionDetailResponse;
  FetchedSessionDetailState({required this.sessionDetailResponse});
}

class FetchingSessionDetailFailureState extends SessionStates {
  FetchingSessionDetailFailureState({required this.message});

  final String message;
}

class FetchingStudentDetailsState extends SessionStates {}

class FetchedStudentDetailState extends SessionStates {
  final TeacherDetails? studentDetails;
  FetchedStudentDetailState({required this.studentDetails});
}

class FetchingStudentDetailFailureState extends SessionStates {
  final String message;
  FetchingStudentDetailFailureState({required this.message});
}

class FetchingTeacherDetailsState extends SessionStates {}

class FetchedTeacherDetailState extends SessionStates {
  final TeacherDetails? teacherDetails;
  FetchedTeacherDetailState({required this.teacherDetails});
}

class FetchingTeacherDetailFailureState extends SessionStates {
  final String message;
  FetchingTeacherDetailFailureState({required this.message});
}
