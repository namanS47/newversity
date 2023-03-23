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

class SaveTagsEvents extends ProfileEvents {
  final List<TagsWithTeacherIdRequestModel> listOfTags;

  SaveTagsEvents({required this.listOfTags});
}

class FetchExamTagsEvent extends ProfileEvents {
  final String tagCat;
  FetchExamTagsEvent({required this.tagCat});
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
