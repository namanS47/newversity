part of 'student_upcoming_session_bloc.dart';

@immutable
abstract class StudentUpcomingSessionStates {}

class StudentUpcomingSessionInitialState extends StudentUpcomingSessionStates {}

class FetchingStudentUpcomingSessionState
    extends StudentUpcomingSessionStates {}

class FetchedStudentUpcomingSessionState extends StudentUpcomingSessionStates {
  final List<SessionDetailResponseModel> listOfUpcomingSession;
  FetchedStudentUpcomingSessionState({required this.listOfUpcomingSession});
}

class UpcomingDataNotFoundState extends StudentUpcomingSessionStates {}

class FetchingStudentUpcomingSessionFailureState
    extends StudentUpcomingSessionStates {
  final String msg;
  FetchingStudentUpcomingSessionFailureState({required this.msg});
}
