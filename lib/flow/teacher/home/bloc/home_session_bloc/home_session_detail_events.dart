part of 'home_session_details_bloc.dart';

@immutable
abstract class HomeSessionDetailEvents {}

class FetchSessionDetailEvent extends HomeSessionDetailEvents {
  final String type;
  FetchSessionDetailEvent({required this.type});
}

class FetchStudentDetailsEvent extends HomeSessionDetailEvents {
  final String studentId;
  FetchStudentDetailsEvent({required this.studentId});
}

class FetchTeacherDetailsEvent extends HomeSessionDetailEvents {
  FetchTeacherDetailsEvent();
}

class FetchProfilePercentageInfoEvent extends HomeSessionDetailEvents {}

class FetchTeacherSessionCountEvent extends HomeSessionDetailEvents {}


