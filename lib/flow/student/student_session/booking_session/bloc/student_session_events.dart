part of 'student_session_bloc.dart';

@immutable
abstract class StudentSessionEvents {}

class UpdateTabBarEvent extends StudentSessionEvents {
  final int index;
  UpdateTabBarEvent({required this.index});
}

class FetchTeacherDetailsEvent extends StudentSessionEvents {
  final String teacherId;
  FetchTeacherDetailsEvent({required this.teacherId});
}

class FetchTeacherExperienceEvent extends StudentSessionEvents {
  final String teacherId;
  FetchTeacherExperienceEvent({required this.teacherId});
}

class FetchTeacherEducationEvent extends StudentSessionEvents {
  final String teacherId;
  FetchTeacherEducationEvent({required this.teacherId});
}

class FetchTeacherAvailabilityEvent extends StudentSessionEvents {
  final FetchAvailabilityRequestModel fetchAvailabilityRequestModel;
  FetchTeacherAvailabilityEvent({required this.fetchAvailabilityRequestModel});
}
