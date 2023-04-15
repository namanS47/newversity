

part of 'student_home_bloc.dart';

@immutable
abstract class StudentHomeEvents {}

class UpdatedNextSessionIndexEvent extends StudentHomeEvents {
  final int nextIndex;
  UpdatedNextSessionIndexEvent({required this.nextIndex});
}

class FetchStudentDetailEvent extends StudentHomeEvents {}