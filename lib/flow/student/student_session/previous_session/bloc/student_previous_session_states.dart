part of 'student_previous_session_bloc.dart';

@immutable
abstract class StudentPreviousSessionState {}

class StudentPreviousSessionInitialState extends StudentPreviousSessionState {}

class FetchingStudentPreviousSessionState extends StudentPreviousSessionState {}

class FetchedStudentPreviousSessionState extends StudentPreviousSessionState {
  final List<SessionDetailResponseModel> listOfPreviousSession;
  FetchedStudentPreviousSessionState({required this.listOfPreviousSession});
}

class PreviousDataNotFoundState extends StudentPreviousSessionState {}

class FetchingStudentPreviousSessionFailureState
    extends StudentPreviousSessionState {
  final String? msg;
  FetchingStudentPreviousSessionFailureState({required this.msg});
}
