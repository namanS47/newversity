part of 'teacher_details_bloc.dart';

@immutable
abstract class TeacherDetailsEvent {}

class SaveTeacherDetailsEvent extends TeacherDetailsEvent {
  SaveTeacherDetailsEvent({required this.teacherDetails});
  final TeacherDetailsModel teacherDetails;
}

class UploadTeacherImageEvent extends TeacherDetailsEvent {
  UploadTeacherImageEvent({required this.file});
  final XFile file;
}

class FetchTeacherDetailEvent extends TeacherDetailsEvent {}
