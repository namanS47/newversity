part of 'student_home_bloc.dart';

@immutable
abstract class StudentHomeStates {}

class StudentHomeInitialState extends StudentHomeStates {}

class UpdatedNextSessionIndexState extends StudentHomeStates {}

class FetchingStudentDetailsState extends StudentHomeStates {}

class FetchedStudentDetailsState extends StudentHomeStates {
  final StudentDetail? studentDetail;
  FetchedStudentDetailsState({required this.studentDetail});
}

class FetchingStudentDetailsFailureState extends StudentHomeStates {
  final String? msg;
  FetchingStudentDetailsFailureState({required this.msg});
}

class FetchingStudentUpcomingSessionState extends StudentHomeStates {}

class FetchedStudentUpcomingSessionState extends StudentHomeStates {
}

class StudentHomeUpcomingSessionNotFoundState extends StudentHomeStates {}

class FetchingStudentUpcomingSessionFailureState extends StudentHomeStates {
  final String? msg;
  FetchingStudentUpcomingSessionFailureState({required this.msg});
}

class FetchingMentorsWithTagState extends StudentHomeStates {}

class FetchedMentorsWithTagState extends StudentHomeStates {
  final List<TeacherDetails> lisOfTeacherDetails;
  FetchedMentorsWithTagState({required this.lisOfTeacherDetails});
}

class FetchingMentorsWithTagFailureState extends StudentHomeStates {
  final String? msg;
  FetchingMentorsWithTagFailureState({required this.msg});
}
