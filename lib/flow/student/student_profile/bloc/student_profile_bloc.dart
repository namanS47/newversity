import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_detail_saving_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';

import '../../../../common/common_utils.dart';
import '../../../../di/di_initializer.dart';
import '../../../../network/webservice/exception.dart';
import '../../../../resources/images.dart';
import '../../../../storage/preferences.dart';
import '../../../teacher/profile/model/tags_response_model.dart';
import '../../profile_dashboard/data/repo/profile_dashboard_repository.dart';
import '../../webservice/student_base_repository.dart';

part 'student_profile_events.dart';

part 'student_profile_states.dart';

class StudentProfileBloc
    extends Bloc<StudentProfileEvents, StudentProfileStates> {
  String studentId = CommonUtils().getLoggedInUser();

  final StudentBaseRepository _studentBaseRepository =
      DI.inject<StudentBaseRepository>();

  final ProfileDashboardRepository _profileDashboardRepository =
      DI.inject<ProfileDashboardRepository>();

  List<String> drawerOptions = <String>[
    ImageAsset.settings,
    ImageAsset.privacyPolicy,
    ImageAsset.termsAndCondition,
    ImageAsset.helpAndSupport,
    ImageAsset.faqs,
  ];

  StudentProfileBloc() : super(StudentProfileInitialState()) {
    on<FetchStudentEvent>((event, emit) async {
      await fetchStudent(event, emit);
    });

    on<LogoutEvent>((event, emit) async {
      await getLoggedOut(event, emit);
    });

    on<FetchProfileCompletenessInfoEvent>((event, emit) async {
      await getProfileCompletionInfo(event, emit);
    });

    on<FetchExamTagEvent>((event, emit) async {
      await fetchExamTag(event, emit);
    });

    on<UploadStudentImageEvent>((event, emit) async {
      await uploadStudentImage(event, emit);
    });

    on<SaveStudentDetailsEvent>((event, emit) async {
      await saveStudentDetails(event, emit);
    });
  }

  Future<void> uploadStudentImage(event, emit) async {
    if (event is UploadStudentImageEvent) {
      emit(StudentImageUploadingState());
      try {
        File newFile = CommonUtils().renameFile(event.file, studentId);
        final response = await _studentBaseRepository.uploadStudentProfileUrl(
            newFile, studentId);
        await newFile.delete();
        emit(StudentImageUploadedState(studentDetail: response));
      } catch (exception) {
        if (exception is BadRequestException) {
          emit(StudentImageUploadingFailureState(
              msg: exception.message.toString()));
        } else {
          emit(StudentImageUploadingFailureState(msg: "Something went wrong"));
        }
      }
    }
  }

  Future<void> fetchStudent(
      FetchStudentEvent event, Emitter<StudentProfileStates> emit) async {
    emit(FetchingStudentState());
    try {
      final studentDetails =
          await _studentBaseRepository.fetchStudentDetails(studentId);
      emit(FetchedStudentState(studentDetail: studentDetails));
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingStudentFailureState(msg: exception.message.toString());
      } else {
        FetchingStudentFailureState(msg: "Something Went Wrong");
      }
    }
  }

  Future<void> fetchExamTag(event, emit) async {
    if (event is FetchExamTagEvent) {
      List<TagsResponseModel> allTags = [];
      try {
        emit(FetchingExamTagState());
        final response = await _profileDashboardRepository.fetchAllTags();
        if (response != null) {
          for (TagsResponseModel x in response) {
            if (event.tagCat == (x.tagCategory)) {
              allTags.add(x);
            }
          }
          await emit(FetchedExamTagState(listOfExamsTags: allTags));
        }
      } catch (exception) {
        if (exception is BadRequestException) {
          await emit(
              FetchingExamTagFailureState(msg: exception.message.toString()));
        } else {
          await emit(FetchingExamTagFailureState(msg: "Something went wrong"));
        }
      }
    }
  }

  Future<void> getProfileCompletionInfo(event, emit) async {
    try {
      emit(FetchingProfileCompletenessInfoState());
      final response =
          await _studentBaseRepository.getProfileCompletionInfo(studentId);
      emit(FetchedProfileCompletenessInfoState(
          profileCompletionPercentageResponse: response));
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingProfileCompletenessInfoFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingProfileCompletenessInfoFailureState(
            msg: "Something went wrong"));
      }
    }
  }

  Future<void> getLoggedOut(event, emit) async {
    if (event is LogoutEvent) {
      await FirebaseAuth.instance.signOut();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await DI.inject<Preferences>().resetFlow();
        emit(LoggedOutState());
      }
    }
  }

  Future<void> saveStudentDetails(event, emit) async {
    emit(SavingStudentDetailsState());
    try {
      if (event is SaveStudentDetailsEvent) {
        final response = await _studentBaseRepository.saveStudentDetails(
            event.studentDetailSavingRequestModel, studentId);
        if (response != null) {
          emit(SavedStudentDetailsState(studentDetail: response));
        }
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(SavingStudentDetailsFailureState(
            msg: exception.message.toString()));
      } else {
        emit(SavingStudentDetailsFailureState(msg: exception.toString()));
      }
    }
  }
}
