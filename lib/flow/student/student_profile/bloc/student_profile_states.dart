part of 'student_profile_bloc.dart';

abstract class StudentProfileStates {}

class StudentProfileInitialState extends StudentProfileStates {}

class FetchingStudentState extends StudentProfileStates {}

class FetchedStudentState extends StudentProfileStates {
  final StudentDetail? studentDetail;
  FetchedStudentState({required this.studentDetail});
}

class FetchingStudentFailureState extends StudentProfileStates {
  final String msg;
  FetchingStudentFailureState({required this.msg});
}

class FetchingProfileCompletenessInfoState extends StudentProfileStates {}

class FetchedProfileCompletenessInfoState extends StudentProfileStates {
  final ProfileCompletionPercentageResponse?
      profileCompletionPercentageResponse;

  FetchedProfileCompletenessInfoState(
      {required this.profileCompletionPercentageResponse});
}

class FetchingProfileCompletenessInfoFailureState extends StudentProfileStates {
  final String msg;
  FetchingProfileCompletenessInfoFailureState({required this.msg});
}

class LoggedOutState extends StudentProfileStates {}

class FetchingExamTagState extends StudentProfileStates {}

class FetchedExamTagState extends StudentProfileStates {
  List<TagsResponseModel> listOfExamsTags;
  FetchedExamTagState({required this.listOfExamsTags});
}

class FetchingExamTagFailureState extends StudentProfileStates {
  final String msg;
  FetchingExamTagFailureState({required this.msg});
}

class StudentImageUploadingState extends StudentProfileStates {}

class StudentImageUploadedState extends StudentProfileStates {
  final StudentDetail? studentDetail;
  StudentImageUploadedState({required this.studentDetail});
}

class StudentImageUploadingFailureState extends StudentProfileStates {
  final String msg;
  StudentImageUploadingFailureState({required this.msg});
}

class SavingStudentDetailsState extends StudentProfileStates {}

class SavedStudentDetailsState extends StudentProfileStates {
  final StudentDetail? studentDetail;
  SavedStudentDetailsState({required this.studentDetail});
}

class SavingStudentDetailsFailureState extends StudentProfileStates {
  final String msg;
  SavingStudentDetailsFailureState({required this.msg});
}
