import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/teacher/profile/model/education_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/education_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_response_model.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../di/di_initializer.dart';
import '../../../webservice/teacher_base_repository.dart';
import '../../model/tags_with_teacher_id_request_model.dart';

part 'profile_events.dart';

part 'profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileStates> {
  int currentProfileStep = 0;
  double sliderWidth = 195.0;
  double sliderPadding = 0.0;
  String teacherId = "";
  int selectedSkinTone = 0;
  List<Widget> profileCardList = <Widget>[];
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();

  ProfileBloc() : super(ProfileInitial()) {
    on<ChangeProfileCardIndexEvent>((event, emit) async {
      await changeIndex(event.index, isBack: event.isBack);
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

    on<FetchMentorshipTag>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await getAllTags(event, emit);
    });
  }

  Future<void> getAllTags(event, emit) async {
    List<TagsResponseModel> allTags = [];
    try {
      emit(FetchingTagsState());
      final response = await _teacherBaseRepository.fetchAllTags();
      print("what is output is ouy $response");
      if (response != null) {
        if (event is FetchExamTagsEvent) {
          for (TagsResponseModel x in response) {
            print("${event.tagCat} --- ${x.tagCategory}");
            if (event.tagCat == (x.tagCategory)) {
              allTags.add(x);
            }
          }
          allTags.add(TagsResponseModel(
            tagName: "others",
            tagCategory: "exams"
          ));
          print("what is output $allTags");
          emit(FetchedExamTagsState(listOfTags: allTags));
        } else if (event is FetchMentorshipTag) {
          for (TagsResponseModel x in response) {
            if (event.tagCat == x.tagCategory) {
              allTags.add(x);
            }
          }
          allTags.add(TagsResponseModel(
              tagName: "others",
              tagCategory: "guidance"
          ));
          emit(FetchedMentorshipTagsState(listOfMentorshipTags: allTags));
        }
      }
    } on SocketException catch (e) {
      emit(FetchingTagsFailure());
    }
  }

  Future<void> saveTagWithTeacherId(event, emit) async {
    try {
      emit(AddingTagsState());
      if(event is SaveTagsEvents){
        await _teacherBaseRepository.saveListOfTags(
            event.listOfTags, teacherId);
      }

      emit(SavedTagsState());
    } on SocketException catch (e) {
      emit(AddingTagsFailureState());
    }
  }

  Future<void> fetchTeacherExperiences(event, emit) async {
    try {
      emit(FetchingTeachersExperiencesState());
      final response = await _teacherBaseRepository
          .fetchAllExperiencesWithTeacherId(teacherId);
      print(response);
      if (response != null) {
        print("Its Coming -- $response");
        emit(
            FetchedTeachersExperiencesState(listOfTeacherExperience: response));
      }
    } on SocketException catch (e) {
      print("Error --- ${e.message}");
      emit(FetchingTagsFailure());
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
    } on SocketException catch (e) {
      emit(FetchingTagsFailure());
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
    } on SocketException catch (e) {
      emit(SavingFailureTeacherExperienceState());
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
    } on SocketException catch (e) {
      emit(SavingFailureTeacherEducationState());
    }
  }

  Future<void> changeIndex(int index, {bool isBack = false}) async {
    emit(ProfileLoading());
    double singlePart = sliderWidth / (profileCardList.length - 1);
    isBack ? sliderPadding -= singlePart : sliderPadding += singlePart;
    isBack ? currentProfileStep -= 1 : currentProfileStep += 1;
    emit(ProfileCardChangedState());
  }
}
