
part of 'mentor_search_bloc.dart';

@immutable
abstract class MentorSearchEvents {}

class GetTagsBySearchKeywordEvent extends MentorSearchEvents {
  GetTagsBySearchKeywordEvent({required this.searchKeyword});
  final String searchKeyword;
}