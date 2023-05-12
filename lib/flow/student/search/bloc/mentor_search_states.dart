part of 'mentor_search_bloc.dart';

@immutable
abstract class MentorSearchStates {}

class MentorSearchInitialState extends MentorSearchStates {}

class FetchingTagBySearchKeywordLoadingState extends MentorSearchStates {}

class FetchingTagBySearchKeywordSuccessState extends MentorSearchStates {}

class FetchingTagBySearchKeywordFailureState extends MentorSearchStates {}

class FetchTeacherListByTagNameLoadingState extends MentorSearchStates {}

class FetchTeacherListByTagNameSuccessState extends MentorSearchStates {
  FetchTeacherListByTagNameSuccessState({required this.teacherDetailsList});

  final List<TeacherDetailsModel> teacherDetailsList;
}

class FetchTeacherListByTagNameFailureState extends MentorSearchStates {}

class FetchAllTeacherListLoadingState extends MentorSearchStates {}

class FetchAllTeacherListSuccessState extends MentorSearchStates {
  FetchAllTeacherListSuccessState({required this.teacherDetailsList});
  final List<TeacherDetailsModel> teacherDetailsList;
}

class FetchAllTeacherListFailureState extends MentorSearchStates {}
