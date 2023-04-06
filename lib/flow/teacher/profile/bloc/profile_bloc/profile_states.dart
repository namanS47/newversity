part of 'profile_bloc.dart';

@immutable
abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class FetchingTeacherProfileState extends ProfileStates {}

class FetchedTeachersProfileState extends ProfileStates {
  final TeacherDetails? teacherDetails;
  FetchedTeachersProfileState({required this.teacherDetails});
}

class FetchingProfileCompletionInfoState extends ProfileStates {}

class FetchedProfileCompletionInfoState extends ProfileStates {
  final ProfileCompletionPercentageResponse? percentageResponse;
  FetchedProfileCompletionInfoState({required this.percentageResponse});
}

class FetchingProfileCompletionInfoFailureState extends ProfileStates {
  final String msg;
  FetchingProfileCompletionInfoFailureState({required this.msg});
}

class UpdateProfileState extends ProfileStates {}

class FetchingTeachersProfileFailureState extends ProfileStates {
  final String msg;
  FetchingTeachersProfileFailureState({required this.msg});
}

class ProfileCardChangedState extends ProfileStates {}

class SavingTeacherExperienceState extends ProfileStates {}

class SavedTeacherExperienceState extends ProfileStates {}

class SavingFailureTeacherExperienceState extends ProfileStates {
  final String msg;
  SavingFailureTeacherExperienceState({required this.msg});
}

class SavingTeacherEducationState extends ProfileStates {}

class SavedTeacherEducationState extends ProfileStates {}

class SavingFailureTeacherEducationState extends ProfileStates {
  final String msg;
  SavingFailureTeacherEducationState({required this.msg});
}

class FetchingTeachersExperiencesState extends ProfileStates {}

class FetchingTeachersEducationState extends ProfileStates {}

class FetchedTeachersExperiencesState extends ProfileStates {
  final List<ExperienceResponseModel> listOfTeacherExperience;
  FetchedTeachersExperiencesState({required this.listOfTeacherExperience});
}

class FetchedTeacherEducationState extends ProfileStates {
  final List<EducationResponseModel> listOfTeacherEducation;
  FetchedTeacherEducationState({required this.listOfTeacherEducation});
}

class FetchingTeacherExperienceFailureState extends ProfileStates {
  final String msg;
  FetchingTeacherExperienceFailureState({required this.msg});
}

class FetchingTeacherEducationFailureState extends ProfileStates {
  final String msg;
  FetchingTeacherEducationFailureState({required this.msg});
}

class AddingTagsState extends ProfileStates {}

class SavedTagsState extends ProfileStates {}

class AddingTagsFailureState extends ProfileStates {
  final String msg;
  AddingTagsFailureState({required this.msg});
}

class FetchingTagsState extends ProfileStates {}

class FetchedExamTagsState extends ProfileStates {
  final List<TagsResponseModel> listOfTags;
  FetchedExamTagsState({required this.listOfTags});
}

class FetchingTagsWithTeacherId extends ProfileStates {}

class FetchingTagsWithTeacherIdFailure extends ProfileStates {
  final String msg;
  FetchingTagsWithTeacherIdFailure({required this.msg});
}

class FetchedExpertiseState extends ProfileStates {
  final List<TagsResponseModel> listOfTags;
  FetchedExpertiseState({required this.listOfTags});
}

class FetchedMentorshipState extends ProfileStates {
  final List<TagsResponseModel> listOfTags;
  FetchedMentorshipState({required this.listOfTags});
}

class FetchedMentorshipTagsState extends ProfileStates {
  final List<TagsResponseModel> listOfMentorshipTags;

  FetchedMentorshipTagsState({required this.listOfMentorshipTags});
}

class FetchingTagsFailure extends ProfileStates {
  final String msg;
  FetchingTagsFailure({required this.msg});
}

class UploadDocumentLoadingState extends ProfileStates {
  UploadDocumentLoadingState({required this.tag});

  final TagsResponseModel tag;
}

class UploadDocumentSuccessState extends ProfileStates {
  UploadDocumentSuccessState({required this.tag});

  final TagsResponseModel tag;
}

class UploadDocumentFailureState extends ProfileStates {
  UploadDocumentFailureState({required this.tag});

  final TagsResponseModel tag;
}

class ProfileDetailsSavingState extends ProfileStates {}

class ProfileDetailsSavingSuccessState extends ProfileStates {}

class ProfileDetailsSavingFailureState extends ProfileStates {
  final String msg;
  ProfileDetailsSavingFailureState({required this.msg});
}
