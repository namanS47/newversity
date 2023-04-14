part of 'student_profile_bloc.dart';

@immutable
abstract class StudentProfileEvents {}

class FetchStudentEvent extends StudentProfileEvents {}

class FetchProfileCompletenessInfoEvent extends StudentProfileEvents {}

class LogoutEvent extends StudentProfileEvents {}

class FetchExamTagEvent extends StudentProfileEvents {
  final String tagCat;
  FetchExamTagEvent({required this.tagCat});
}

class UploadStudentImageEvent extends StudentProfileEvents {
  final XFile file;
  UploadStudentImageEvent({required this.file});
}

class SaveStudentDetailsEvent extends StudentProfileEvents {
  final StudentDetailSavingRequestModel studentDetailSavingRequestModel;
  SaveStudentDetailsEvent({required this.studentDetailSavingRequestModel});
}
