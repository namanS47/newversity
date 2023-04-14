part of 'student_session_bloc.dart';

@immutable
abstract class StudentSessionStates {}

class StudentSessionInitialState extends StudentSessionStates {}

class UpdatedTabBarState extends StudentSessionStates {}

class FetchingTeacherDetailsState extends StudentSessionStates {}

class FetchedTeacherDetailsState extends StudentSessionStates {
  final TeacherDetails? teacherDetails;
  FetchedTeacherDetailsState({required this.teacherDetails});
}

class FetchingTeacherDetailsFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherDetailsFailureState({required this.msg});
}

class FetchingTeacherExperienceState extends StudentSessionStates {}

class FetchedTeacherExperienceState extends StudentSessionStates {
  final List<ExperienceResponseModel> listOfTeacherExperience;
  FetchedTeacherExperienceState({required this.listOfTeacherExperience});
}

class FetchingTeacherExperienceFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherExperienceFailureState({required this.msg});
}

class FetchingTeacherEducationState extends StudentSessionStates {}

class FetchedTeacherEducationState extends StudentSessionStates {
  final List<EducationResponseModel> listOfTeacherEducation;
  FetchedTeacherEducationState({required this.listOfTeacherEducation});
}

class FetchingTeacherEducationFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherEducationFailureState({required this.msg});
}

class FetchingTeacherAvailabilityState extends StudentSessionStates {}

class FetchedTeacherAvailabilityState extends StudentSessionStates {
  FetchedTeacherAvailabilityState({required this.availabilityList});

  final List<AvailabilityModel> availabilityList;
}

class FetchingTeacherAvailabilityFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherAvailabilityFailureState({required this.msg});
}
