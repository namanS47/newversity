part of 'student_session_bloc.dart';

@immutable
abstract class StudentSessionStates {}

class StudentSessionInitialState extends StudentSessionStates {}

class UpdatedTabBarState extends StudentSessionStates {}

class FetchingTeacherDetailsState extends StudentSessionStates {}

class FetchedTeacherDetailsState extends StudentSessionStates {
  final TeacherDetailsModel? teacherDetails;
  FetchedTeacherDetailsState({required this.teacherDetails});
}

class FetchingTeacherDetailsFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherDetailsFailureState({required this.msg});
}

class FetchingTeacherExperienceState extends StudentSessionStates {}

class FetchedTeacherExperienceState extends StudentSessionStates {
  final List<ExperienceDetailsModel> listOfTeacherExperience;
  FetchedTeacherExperienceState({required this.listOfTeacherExperience});
}

class FetchingTeacherExperienceFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherExperienceFailureState({required this.msg});
}

class FetchingTeacherEducationState extends StudentSessionStates {}

class FetchedTeacherEducationState extends StudentSessionStates {
  final List<EducationDetailsModel> listOfTeacherEducation;
  FetchedTeacherEducationState({required this.listOfTeacherEducation});
}

class FetchingTeacherEducationFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherEducationFailureState({required this.msg});
}

class FetchingTeacherAvailabilityState extends StudentSessionStates {}

class FetchedTeacherAvailabilityState extends StudentSessionStates {
  FetchedTeacherAvailabilityState({required this.availabilityList});

  final Map<String, List<AvailabilityModel>> availabilityList;
}

class NotTeacherSlotFoundState extends StudentSessionStates {}

class FetchingTeacherAvailabilityFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherAvailabilityFailureState({required this.msg});
}

class FetchingTeacherSessionTimingsState extends StudentSessionStates {}

class FetchedTeacherSessionTimingsState extends StudentSessionStates {
  FetchedTeacherSessionTimingsState({required this.availabilityList});

  final List<AvailabilityModel> availabilityList;
}

class FetchingTeacherSessionTimingsFailureState extends StudentSessionStates {
  final String msg;
  FetchingTeacherSessionTimingsFailureState({required this.msg});
}

class UpdatedAvailabilityIndexState extends StudentSessionStates {}

class UpdateSelectedDateTimeIndexState extends StudentSessionStates {}

class BookingSessionState extends StudentSessionStates {}

class BookedSessionState extends StudentSessionStates {}

class BookingSessionFailureState extends StudentSessionStates {
  final String msg;
  BookingSessionFailureState({required this.msg});
}

class FetchPromoCodeDetailsLoadingState extends StudentSessionStates {}

class FetchPromoCodeDetailsSuccessState extends StudentSessionStates {
  FetchPromoCodeDetailsSuccessState({required this.promoCodeDetails});
  final PromoCodeDetailsResponseModel promoCodeDetails;
}

class FetchPromoCodeDetailsFailureState extends StudentSessionStates {
  FetchPromoCodeDetailsFailureState({this.message});
  final String? message;
}

class RequestSessionLoadingState extends StudentSessionStates {}

class RequestSessionSuccessState extends StudentSessionStates {}

class RequestSessionFailureState extends StudentSessionStates {
  RequestSessionFailureState({this.message});
  final String? message;
}
