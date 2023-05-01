part of 'profile_dahsbord_bloc.dart';

@immutable
abstract class ProfileDashboardStates {}

class ProfileDashboardInitialState extends ProfileDashboardStates {}

class ProfileDashboardCardChangedState extends ProfileDashboardStates {}

class FetchingExamTagState extends ProfileDashboardInitialState {}

class FetchedExamTagState extends ProfileDashboardInitialState {
  List<TagsResponseModel> listOfExamsTags;
  FetchedExamTagState({required this.listOfExamsTags});
}

class FetchingExamTagFailureState extends ProfileDashboardInitialState {
  final String msg;
  FetchingExamTagFailureState({required this.msg});
}

class StudentDetailsSavingState extends ProfileDashboardInitialState {}

class StudentDetailsSavedState extends ProfileDashboardInitialState {
  final StudentDetail? studentDetail;
  StudentDetailsSavedState({required this.studentDetail});
}

class StudentDetailsSavingFailureState extends ProfileDashboardInitialState {
  final String msg;
  StudentDetailsSavingFailureState({required this.msg});
}

class StudentDetailsSavingOnSkipState extends ProfileDashboardInitialState {}

class StudentDetailsSavedOnSkipState extends ProfileDashboardInitialState {
  final StudentDetail? studentDetail;
  StudentDetailsSavedOnSkipState({required this.studentDetail});
}

class StudentDetailsSavingOnSkipFailureState
    extends ProfileDashboardInitialState {
  final String msg;
  StudentDetailsSavingOnSkipFailureState({required this.msg});
}

class FetchingStudentDetailState extends ProfileDashboardStates {}

class FetchingStudentDetailFailureState extends ProfileDashboardStates {
  final String msg;
  FetchingStudentDetailFailureState({required this.msg});
}

class FetchedStudentDetailState extends ProfileDashboardStates {}

class AddingTagState extends ProfileDashboardStates {}

class AddedTagState extends ProfileDashboardStates {}

class AddingTagFailureState extends ProfileDashboardStates {
  final String msg;
  AddingTagFailureState({required this.msg});
}
