part of 'teacher_details_bloc.dart';

@immutable
abstract class TeacherDetailsState {}

class TeacherDetailsInitial extends TeacherDetailsState {}

class TeacherDetailsSavingState extends TeacherDetailsState{}

class TeacherDetailsSavingSuccessState extends TeacherDetailsState {}

class TeacherDetailsSavingFailureState extends TeacherDetailsState {}
