part of 'profile_dahsbord_bloc.dart';

@immutable
abstract class ProfileDashboardEvents {}

class ChangeProfileCardIndexEvent extends ProfileDashboardEvents {
  final bool isBack;

  ChangeProfileCardIndexEvent({this.isBack = false});
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
