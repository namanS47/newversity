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
