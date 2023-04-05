part of 'teacher_details_bloc.dart';

@immutable
abstract class TeacherDetailsState {}

class TeacherDetailsInitial extends TeacherDetailsState {}

class TeacherDetailsSavingState extends TeacherDetailsState{}

class TeacherDetailsSavingSuccessState extends TeacherDetailsState {}

class TeacherDetailsSavingFailureState extends TeacherDetailsState {}

class TeacherImageUploadLoadingState extends TeacherDetailsState {}

class TeacherImageUploadSuccessState extends TeacherDetailsState {}

class TeacherImageUploadFailureState extends TeacherDetailsState {}

class FetchTeacherDetailLoadingState extends TeacherDetailsState {}

class FetchTeacherDetailSuccessState extends TeacherDetailsState {}

class FetchTeacherDetailFailureState extends TeacherDetailsState {}
