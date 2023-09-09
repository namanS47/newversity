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

class FetchTeacherSessionTimingsEvent extends StudentSessionEvents {
  final FetchAvailabilityRequestModel fetchAvailabilityRequestModel;
  FetchTeacherSessionTimingsEvent(
      {required this.fetchAvailabilityRequestModel});
}

class UpdateDateIndexOfAvailabilityEvent extends StudentSessionEvents {
  final int index;
  UpdateDateIndexOfAvailabilityEvent({required this.index});
}

class UpdateSelectedDateTimeEvent extends StudentSessionEvents {
  final SelectedDateTimeModel currentSelectedDateTime;
  UpdateSelectedDateTimeEvent({required this.currentSelectedDateTime});
}

class SessionAddingEvent extends StudentSessionEvents {
  final SessionSaveRequest sessionSaveRequest;
  SessionAddingEvent({required this.sessionSaveRequest});
}

class FetchPromoCodeDetailsEvent extends StudentSessionEvents {
  FetchPromoCodeDetailsEvent({required this.promoCode});
  final String promoCode;
}

class RequestSessionEvent extends StudentSessionEvents {}
