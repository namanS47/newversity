part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvents {}

class ChangeProfileCardIndexEvent extends ProfileEvents {
  final bool isBack;

  ChangeProfileCardIndexEvent({this.isBack = false});
}

class FetchTeachersExperienceEvent extends ProfileEvents {
  FetchTeachersExperienceEvent();
}

class FetchTeachersEducationEvents extends ProfileEvents {
  FetchTeachersEducationEvents();
}

class ChangeProfileTab extends ProfileEvents {
  final int index;
  ChangeProfileTab({required this.index});
}

class SaveTagsEvents extends ProfileEvents {
  final String category;
  final List<TagModel> listOfTags;

  SaveTagsEvents({required this.category, required this.listOfTags});
}

class FetchExamTagsEvent extends ProfileEvents {
  final String tagCat;
  FetchExamTagsEvent({required this.tagCat});
}

class FetchTagEventByTeacherId extends ProfileEvents {}

class FetchMentorshipTag extends ProfileEvents {
  final String tagCat;
  FetchMentorshipTag({required this.tagCat});
}

class SaveTeacherExperienceEvent extends ProfileEvents {
  final ExperienceDetailsModel experienceRequestModel;
  SaveTeacherExperienceEvent({required this.experienceRequestModel});
}

class SaveTeacherEducationEvents extends ProfileEvents {
  final EducationDetailsModel educationDetailsModel;
  SaveTeacherEducationEvents({required this.educationDetailsModel});
}

class DeleteTeacherEducationEvent extends ProfileEvents {
  DeleteTeacherEducationEvent({required this.id});
  final String id;
}

class DeleteTeacherExperienceEvent extends ProfileEvents {
  DeleteTeacherExperienceEvent({required this.id});
  final String id;
}

class FetchTeacherDetailsEvent extends ProfileEvents {}

class FetchProfileCompletionInfoEvent extends ProfileEvents {}

class UploadDocumentEvent extends ProfileEvents {
  UploadDocumentEvent({required this.file, required this.tag});

  final XFile file;
  final TagsResponseModel tag;
}

class SaveProfileDetailsEvent extends ProfileEvents {
  SaveProfileDetailsEvent({required this.teacherDetails});
  final TeacherDetailsModel teacherDetails;
}