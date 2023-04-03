part of 'session_details_bloc.dart';

@immutable
abstract class SessionDetailStates {}

class SessionDetailInitialState extends SessionDetailStates {}

class FetchingSessionDetailState extends SessionDetailInitialState {}

class FetchedSessionDetailState extends SessionDetailStates {
  final List<SessionDetailsResponse>? sessionDetailResponse;
  FetchedSessionDetailState({required this.sessionDetailResponse});
}

class FetchingSessionDetailFailureState extends SessionDetailStates {
  FetchingSessionDetailFailureState({required this.message});

  final String message;
}

class FetchingStudentDetailsState extends SessionDetailStates {}

class FetchedStudentDetailState extends SessionDetailStates {
  final TeacherDetails? studentDetails;
  FetchedStudentDetailState({required this.studentDetails});
}

class FetchingStudentDetailFailureState extends SessionDetailStates {
  final String message;
  FetchingStudentDetailFailureState({required this.message});
}

class SavingSessionDetailState extends SessionDetailStates {}

class SavedSessionDetails extends SessionDetailStates {}

class SavingSessionDetailFailureState extends SessionDetailStates {
  final String message;
  SavingSessionDetailFailureState({required this.message});
}
