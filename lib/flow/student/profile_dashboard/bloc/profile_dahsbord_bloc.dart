import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/add_tag_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/repo/profile_dashboard_repository.dart';
import 'package:newversity/flow/student/webservice/student_base_repository.dart';

import '../../../../common/common_utils.dart';
import '../../../../di/di_initializer.dart';
import '../../../../network/webservice/exception.dart';
import '../../../../storage/preferences.dart';
import '../../../teacher/profile/model/tags_response_model.dart';
import '../data/model/student_detail_saving_request_model.dart';

part 'profile_dashboard_events.dart';

part 'profile_dashboard_states.dart';

class ProfileDashboardBloc
    extends Bloc<ProfileDashboardEvents, ProfileDashboardStates> {
  final ProfileDashboardRepository _profileDashboardRepository =
      DI.inject<ProfileDashboardRepository>();

  final StudentBaseRepository _studentBaseRepository =
      DI.inject<StudentBaseRepository>();

  int currentProfileStep = 1;
  double sliderWidth = 195.0;
  double sliderPadding = 0.0;
  int selectedProfileTab = 0;
  StudentDetail? studentDetail;
  String studentId = CommonUtils().getLoggedInUser();
  List<Widget> profileCardList = <Widget>[];

  ProfileDashboardBloc() : super(ProfileDashboardInitialState()) {
    on<ChangeProfileCardIndexEvent>((event, emit) async {
      await changeIndex(isBack: event.isBack);
      emit(ProfileDashboardCardChangedState());
    });

    on<StudentDetailSaveEvent>((event, emit) async {
      await saveStudentDetails(event, emit);
    });

    on<FetchStudentDetailEvent>((event, emit) async {
      await fetchStudentDetails(event, emit);
    });

    on<StudentDetailSavingOnSkipEvent>((event, emit) async {
      await saveStudentDetailsOnSkip(event, emit);
    });

    on<FetchExamTagEvent>((event, emit) async {
      await fetchExamTag(event, emit);
    });

    on<AddTagsEvent>((event, emit) async {
      await addTags(event, emit);
    });
  }

  Future<void> addTags(event, emit) async {
    emit(AddingTagState());
    try {
      if (event is AddTagsEvent) {
        await _studentBaseRepository.addTags(event.addTagRequestModel);
        emit(AddedTagState());
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(AddingTagFailureState(msg: exception.message.toString()));
      } else {
        emit(AddingTagFailureState(msg: exception.toString()));
      }
    }
  }

  Future<void> fetchStudentDetails(event, emit) async {
    emit(FetchingStudentDetailState());
    try {
      final response =
          await _studentBaseRepository.fetchStudentDetails(studentId);
      if (response != null) {
        studentDetail = response;
      }
      await emit(FetchedStudentDetailState());
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingStudentDetailFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingStudentDetailFailureState(msg: "Something went wrong"));
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
          allTags
              .add(TagsResponseModel(tagName: "others", tagCategory: "exams"));
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

  Future<void> saveStudentDetails(event, emit) async {
    emit(StudentDetailsSavingState());
    try {
      if (event is StudentDetailSaveEvent) {
        final response = await _studentBaseRepository.saveStudentDetails(
            event.studentDetailSavingRequestModel, studentId);
        if (response != null) {
          emit(StudentDetailsSavedState(studentDetail: response));
        }
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(StudentDetailsSavingFailureState(
            msg: exception.message.toString()));
      } else {
        emit(StudentDetailsSavingFailureState(msg: exception.toString()));
      }
    }
  }

  Future<void> saveStudentDetailsOnSkip(event, emit) async {
    emit(StudentDetailsSavingOnSkipState());
    try {
      event.studentDetailSavingRequestModel.mobileNumber =
          await DI.inject<Preferences>().getMobileNumber();
      if (event is StudentDetailSavingOnSkipEvent) {
        final response = await _studentBaseRepository.saveStudentDetails(
            event.studentDetailSavingRequestModel, studentId);
        if (response != null) {
          emit(StudentDetailsSavedOnSkipState(studentDetail: response));
        }
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(StudentDetailsSavingOnSkipFailureState(
            msg: exception.message.toString()));
      } else {
        emit(StudentDetailsSavingOnSkipFailureState(
            msg: "Something went wrong"));
      }
    }
  }

  changeIndex({bool isBack = false}) {
    double singlePart = sliderWidth / (profileCardList.length - 1);
    isBack ? sliderPadding -= singlePart : sliderPadding += singlePart;
    isBack ? currentProfileStep -= 1 : currentProfileStep += 1;
  }
}
