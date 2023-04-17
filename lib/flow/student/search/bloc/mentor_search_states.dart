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

  final List<TeacherDetails> teacherDetailsList;
}

class FetchTeacherListByTagNameFailureState extends MentorSearchStates {}
