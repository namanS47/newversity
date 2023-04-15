part of 'student_home_bloc.dart';

@immutable
abstract class StudentHomeStates {}

class StudentHomeInitialState extends StudentHomeStates {}

class UpdatedNextSessionIndexState extends StudentHomeStates {}

class FetchingStudentDetailsState extends StudentHomeStates {}

class FetchedStudentDetailsState extends StudentHomeStates {
  final StudentDetail? studentDetail;
  FetchedStudentDetailsState({required this.studentDetail});
}

class FetchingStudentDetailsFailureState extends StudentHomeStates {
  final String? msg;
  FetchingStudentDetailsFailureState({required this.msg});
}
