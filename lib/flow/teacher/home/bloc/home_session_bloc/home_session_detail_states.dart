part of 'home_session_details_bloc.dart';

@immutable
abstract class HomeSessionStates {}

class SessionDetailInitialState extends HomeSessionStates {}

class FetchingSessionDetailState extends SessionDetailInitialState {}

class FetchedSessionDetailState extends HomeSessionStates {
  final List<SessionDetailsResponse>? sessionDetailResponse;
  FetchedSessionDetailState({required this.sessionDetailResponse});
}

class FetchingSessionDetailFailureState extends HomeSessionStates {
  final String message;
  FetchingSessionDetailFailureState({required this.message});
}

class FetchingProfileCompletionInfoState extends HomeSessionStates {}

class FetchedProfileCompletionInfoState extends HomeSessionStates {
  final ProfileCompletionPercentageResponse? percentageResponse;
  FetchedProfileCompletionInfoState({required this.percentageResponse});
}

class FetchingProfileCompletionInfoFailureState extends HomeSessionStates {
  final String msg;
  FetchingProfileCompletionInfoFailureState({required this.msg});
}

class FetchingStudentDetailsState extends HomeSessionStates {}

class FetchedStudentDetailState extends HomeSessionStates {
  final StudentDetail? studentDetails;
  FetchedStudentDetailState({required this.studentDetails});
}

class FetchingStudentDetailFailureState extends HomeSessionStates {
  final String message;
  FetchingStudentDetailFailureState({required this.message});
}

class FetchingTeacherDetailsState extends HomeSessionStates {}

class FetchedTeacherDetailState extends HomeSessionStates {
  final TeacherDetails? teacherDetails;
  FetchedTeacherDetailState({required this.teacherDetails});
}

class FetchingTeacherDetailFailureState extends HomeSessionStates {
  final String message;
  FetchingTeacherDetailFailureState({required this.message});
}
