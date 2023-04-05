import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/profile/model/education_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/education_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/flow/teacher/profile/model/tags_response_model.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../di/di_initializer.dart';
import '../../../webservice/teacher_base_repository.dart';
import '../../model/tags_with_teacher_id_request_model.dart';

part 'profile_events.dart';

part 'profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileStates> {
  int currentProfileStep = 1;
  double sliderWidth = 195.0;
  double sliderPadding = 0.0;
  String teacherId = "";
  int selectedSkinTone = 0;
  int selectedProfileTab = 0;
  List<String> listOfProfileSection = ["Overview", "Review"];
  List<Widget> profileCardList = <Widget>[];
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();

  ProfileBloc() : super(ProfileInitial()) {
    on<ChangeProfileCardIndexEvent>((event, emit) async {
      changeIndex(isBack: event.isBack);
      emit(ProfileCardChangedState());
    });

    on<ChangeProfileTab>((event, emit) async {
      updateProfileTab(event, emit);
    });

    on<FetchTeachersExperienceEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await fetchTeacherExperiences(event, emit);
    });

    on<FetchTeachersEducationEvents>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await fetchTeacherEducation(event, emit);
    });

    on<SaveTeacherExperienceEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await saveTeacherExperience(event, emit);
    });

    on<SaveTeacherEducationEvents>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await saveTeacherEducation(event, emit);
    });

    on<SaveTagsEvents>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await saveTagWithTeacherId(event, emit);
    });

    on<FetchExamTagsEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await getAllTags(event, emit);
    });

    on<FetchTagEventByTeacherId>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await getAllTagsByTeacherId(event, emit);
    });

    on<FetchMentorshipTag>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await getAllTags(event, emit);
    });

    on<FetchTeacherDetailsEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await getTeacherDetails(event, emit);
    });

    on<FetchProfileCompletionInfoEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await getProfileCompletionInfo(event, emit);
    });

    on<UploadDocumentEvent>((event, emit) async {
      emit(UploadDocumentLoadingState(tag: event.tag));
      try{
        File newFile = CommonUtils().renameFile(event.file, teacherId);
        await _teacherBaseRepository.uploadTagDocument(
            newFile, teacherId, event.tag.tagName ?? "");
        newFile.delete();
        emit(UploadDocumentSuccessState(tag: event.tag));
      } catch(exception) {
        emit(UploadDocumentFailureState(tag: event.tag));
      }
    });
  }

  Future<void> updateProfileTab(event, emit) async {
    if (event is ChangeProfileTab) {
      selectedProfileTab = event.index;
      emit(UpdateProfileState());
    }
  }

  Future<void> getAllTagsByTeacherId(event, emit) async {
    List<TagsResponseModel> listOfExpertise = [];
    List<TagsResponseModel> listOfMentorship = [];
    try {
      emit(FetchingTagsWithTeacherId());
      final response =
          await _teacherBaseRepository.fetchAllTagsWithTeacherId(teacherId);
      if (response != null) {
        for (TagsResponseModel x in response) {
          if (x.tagCategory == "exams") {
            listOfExpertise.add(x);
          } else {
            listOfMentorship.add(x);
          }
        }
        emit(FetchedExpertiseState(listOfTags: listOfExpertise));
        emit(FetchedMentorshipState(listOfTags: listOfMentorship));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTagsWithTeacherIdFailure(
            msg: exception.message.toString()));
      } else {
        emit(FetchingTagsWithTeacherIdFailure(msg: "Something went wrong"));
      }
    }
  }

  Future<void> getTeacherDetails(event, emit) async {
    try {
      emit(FetchingTeacherProfileState());
      final response =
          await _teacherBaseRepository.getTeachersDetail(teacherId);
      emit(FetchedTeachersProfileState(teacherDetails: response));
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTeachersProfileFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingTeachersProfileFailureState(msg: "Something went wrong"));
      }
    }
  }

  Future<void> getProfileCompletionInfo(event, emit) async {
    try {
      emit(FetchingProfileCompletionInfoState());
      final response =
          await _teacherBaseRepository.getProfileCompletionInfo(teacherId);
      emit(FetchedProfileCompletionInfoState(percentageResponse: response));
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingProfileCompletionInfoFailureState(
            msg: exception.message.toString()));
      }
    }
  }

  Future<void> getAllTags(event, emit) async {
    List<TagsResponseModel> allTags = [];
    try {
      emit(FetchingTagsState());
      final response = await _teacherBaseRepository.fetchAllTags();
      if (response != null) {
        if (event is FetchExamTagsEvent) {
          for (TagsResponseModel x in response) {
            if (event.tagCat == (x.tagCategory)) {
              allTags.add(x);
            }
          }
          allTags
              .add(TagsResponseModel(tagName: "others", tagCategory: "exams"));
          emit(FetchedExamTagsState(listOfTags: allTags));
        } else if (event is FetchMentorshipTag) {
          for (TagsResponseModel x in response) {
            if (event.tagCat == x.tagCategory) {
              allTags.add(x);
            }
          }
          allTags.add(
              TagsResponseModel(tagName: "others", tagCategory: "guidance"));
          emit(FetchedMentorshipTagsState(listOfMentorshipTags: allTags));
        }
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTagsFailure(msg: exception.message.toString()));
      } else {
        emit(FetchingTagsFailure(msg: "Something went wrong"));
      }
    }
  }

  Future<void> saveTagWithTeacherId(event, emit) async {
    try {
      emit(AddingTagsState());
      if (event is SaveTagsEvents) {
        await _teacherBaseRepository.saveListOfTags(
            event.category, event.listOfTags, teacherId);
      }

      emit(SavedTagsState());
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(AddingTagsFailureState(msg: exception.message.toString()));
      } else {
        emit(AddingTagsFailureState(msg: "Something went wrong"));
      }
    }
  }

  Future<void> fetchTeacherExperiences(event, emit) async {
    try {
      emit(FetchingTeachersExperiencesState());
      final response = await _teacherBaseRepository
          .fetchAllExperiencesWithTeacherId(teacherId);
      if (response != null) {
        emit(
            FetchedTeachersExperiencesState(listOfTeacherExperience: response));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTagsFailure(msg: exception.message.toString()));
      } else {
        emit(FetchingTagsFailure(msg: "Something went wrong"));
      }
    }
  }

  Future<void> fetchTeacherEducation(event, emit) async {
    try {
      emit(FetchingTeachersEducationState());
      final response = await _teacherBaseRepository
          .fetchAllEducationWithTeacherId(teacherId);
      if (response != null) {
        emit(FetchedTeacherEducationState(listOfTeacherEducation: response));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTeacherEducationFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingTeacherEducationFailureState(msg: "Something went wrong"));
      }
    }
  }

  Future<void> saveTeacherExperience(event, emit) async {
    try {
      emit(SavingTeacherExperienceState());
      if (event is SaveTeacherExperienceEvent) {
        await _teacherBaseRepository.saveTeachersExperience(
            event.experienceRequestModel, teacherId);
      }
      emit(SavedTeacherExperienceState());
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(SavingFailureTeacherExperienceState(
            msg: exception.message.toString()));
      } else {
        emit(SavingFailureTeacherExperienceState(msg: "Something went wrong"));
      }
    }
  }

  Future<void> saveTeacherEducation(event, emit) async {
    try {
      emit(SavingTeacherEducationState());
      if (event is SaveTeacherEducationEvents) {
        await _teacherBaseRepository.saveTeachersEducation(
            event.educationRequestModel, teacherId);
      }
      emit(SavedTeacherEducationState());
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(SavingFailureTeacherEducationState(
            msg: exception.message.toString()));
      } else {
        emit(SavingFailureTeacherEducationState(msg: "Something went wrong"));
      }
    }
  }

  changeIndex({bool isBack = false}) {
    double singlePart = sliderWidth / (profileCardList.length - 1);
    isBack ? sliderPadding -= singlePart : sliderPadding += singlePart;
    isBack ? currentProfileStep -= 1 : currentProfileStep += 1;
  }
}
