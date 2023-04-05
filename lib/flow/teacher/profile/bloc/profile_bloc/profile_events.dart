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
  int index;
  ChangeProfileTab({required this.index});
}

class SaveTagsEvents extends ProfileEvents {
  final List<TagModel> listOfTags;

  SaveTagsEvents({required this.listOfTags});
}

class FetchExamTagsEvent extends ProfileEvents {
  final String tagCat;
  FetchExamTagsEvent({required this.tagCat});
}

class FetchTagEventByTeacherId extends ProfileEvents {
}

class FetchMentorshipTag extends ProfileEvents {
  final String tagCat;
  FetchMentorshipTag({required this.tagCat});
}

class SaveTeacherExperienceEvent extends ProfileEvents {
  final ExperienceRequestModel experienceRequestModel;
  SaveTeacherExperienceEvent({required this.experienceRequestModel});
}

class SaveTeacherEducationEvents extends ProfileEvents {
  final EducationRequestModel educationRequestModel;
  SaveTeacherEducationEvents({required this.educationRequestModel});
}

class FetchTeacherDetails extends ProfileEvents {}

class UploadDocumentEvent extends ProfileEvents {
  UploadDocumentEvent({required this.file, required this.tag});
  final XFile file;
  final TagsResponseModel tag;
}
