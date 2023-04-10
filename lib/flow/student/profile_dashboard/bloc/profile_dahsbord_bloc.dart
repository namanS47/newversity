import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
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
  String studentId = CommonUtils().getLoggedInUser();
  List<Widget> profileCardList = <Widget>[];

  ProfileDashboardBloc() : super(ProfileDashboardInitialState()) {
    on<ChangeProfileCardIndexEvent>((event, emit) async {
      changeIndex(isBack: event.isBack);
      emit(ProfileDashboardCardChangedState());
    });

    on<StudentDetailSaveEvent>((event, emit) async{
     await saveStudentDetails(event, emit);
    });

    on<FetchExamTagEvent>((event, emit) async{
      await fetchExamTag(event, emit);
    });
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
          await emit(FetchingExamTagFailureState(msg: exception.message.toString()));
        } else {
          await emit(FetchingExamTagFailureState(msg: "Something went wrong"));
        }
      }
    }
  }

  Future<void> saveStudentDetails(event, emit) async {
    if (event is StudentDetailSaveEvent) {
      emit(StudentDetailsSavingState());
      try {
        event.studentDetailSavingRequestModel.mobileNumber =
        await DI.inject<Preferences>().getMobileNumber();
        final response = await _studentBaseRepository.saveStudentDetails(
            event.studentDetailSavingRequestModel, studentId);
        if (response != null) {
          await emit(StudentDetailsSavedState(studentDetail: response));
        }
      } catch (exception){
        if (exception is BadRequestException) {
          await emit(StudentDetailsSavingFailureState(
              msg: exception.message.toString()));
        } else {
          await emit(StudentDetailsSavingFailureState(msg: "Something went wrong"));
        }
      }
    }
  }

  changeIndex({bool isBack = false}) {
    double singlePart = sliderWidth / (profileCardList.length - 1);
    isBack ? sliderPadding -= singlePart : sliderPadding += singlePart;
    isBack ? currentProfileStep -= 1 : currentProfileStep += 1;
  }
}
