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

class FetchTeacherDetailEvent extends HomeSessionDetailEvents {
  FetchTeacherDetailEvent();
}

class FetchProfilePercentageInfoEvent extends HomeSessionDetailEvents {}


