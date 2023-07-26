part of 'profile_dahsbord_bloc.dart';

@immutable
abstract class ProfileDashboardEvents {}

class ChangeStudentProfileCardIndexEvent extends ProfileDashboardEvents {
  final bool isBack;

  ChangeStudentProfileCardIndexEvent({this.isBack = false});
}

class ChangeProfileTab extends ProfileDashboardEvents {
  final int index;
  ChangeProfileTab({required this.index});
}

class FetchExamTagEvent extends ProfileDashboardEvents {
  final String tagCat;
  FetchExamTagEvent({required this.tagCat});
}

class StudentDetailSaveEvent extends ProfileDashboardEvents {
  StudentDetailSavingRequestModel studentDetailSavingRequestModel;
  StudentDetailSaveEvent({required this.studentDetailSavingRequestModel});
}

class StudentDetailSavingOnSkipEvent extends ProfileDashboardEvents {
  StudentDetailSavingRequestModel studentDetailSavingRequestModel;
  StudentDetailSavingOnSkipEvent(
      {required this.studentDetailSavingRequestModel});
}

class FetchStudentDetailEvent extends ProfileDashboardEvents {}

class AddTagsEvent extends ProfileDashboardEvents {
  final AddTagRequestModel addTagRequestModel;
  AddTagsEvent({required this.addTagRequestModel});
}
