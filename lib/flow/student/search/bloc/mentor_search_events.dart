
part of 'mentor_search_bloc.dart';

@immutable
abstract class MentorSearchEvents {}

class GetTagsBySearchKeywordEvent extends MentorSearchEvents {
  GetTagsBySearchKeywordEvent({required this.searchKeyword});
  final String searchKeyword;
}

class FetchTeacherListByTagNameEvent extends MentorSearchEvents {
  FetchTeacherListByTagNameEvent({required this.tagName});
  final String tagName;
}

class FetchAllMentorsListEvent extends MentorSearchEvents{}