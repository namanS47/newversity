part of 'profile_bloc.dart';

@immutable
abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class FetchingTeacherProfile extends ProfileStates {}

class FetchedTeachersProfile extends ProfileStates {
  TeacherDetails teacherDetails;
  FetchedTeachersProfile({required this.teacherDetails});
}

class UpdateProfileState extends ProfileStates {}

class FetchingTeachersProfileFailure extends ProfileStates {}

class ProfileCardChangedState extends ProfileStates {}

class SavingTeacherExperienceState extends ProfileStates {}

class SavedTeacherExperienceState extends ProfileStates {}

class SavingFailureTeacherExperienceState extends ProfileStates {}

class SavingTeacherEducationState extends ProfileStates {}

class SavedTeacherEducationState extends ProfileStates {}

class SavingFailureTeacherEducationState extends ProfileStates {}

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

class FetchingTeacherExperienceFailureState extends ProfileStates {}

class FetchingTeacherEducationFailureState extends ProfileStates {}

class AddingTagsState extends ProfileStates {}

class SavedTagsState extends ProfileStates {}

class AddingTagsFailureState extends ProfileStates {}

class FetchingTagsState extends ProfileStates {}

class FetchedExamTagsState extends ProfileStates {
  final List<TagsResponseModel> listOfTags;
  FetchedExamTagsState({required this.listOfTags});
}

class FetchingTagsWithTeacherId extends ProfileStates{
}

class FetchingTagsWithTeacherIdFailure extends ProfileStates{}

class FetchedExpertiesState extends ProfileStates {
  final List<TagsResponseModel> listOfTags;
  FetchedExpertiesState({required this.listOfTags});
}

class FetchedMentorsipState extends ProfileStates {
  final List<TagsResponseModel> listOfTags;
  FetchedMentorsipState({required this.listOfTags});
}

class FetchedMentorshipTagsState extends ProfileStates {
  final List<TagsResponseModel> listOfMentorshipTags;

  FetchedMentorshipTagsState({required this.listOfMentorshipTags});
}

class FetchingTagsFailure extends ProfileStates {}
