import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/flow/teacher/home/model/session_response_model.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../di/di_initializer.dart';
import '../../../../model/session_count_response_model.dart';
import '../../../../student/student_session/my_session/model/session_detail_response_model.dart';
import '../../../../student/webservice/student_base_repository.dart';
import '../../../profile/model/profile_completion_percentage_response.dart';
import '../../../webservice/teacher_base_repository.dart';

part 'home_session_detail_events.dart';

part 'home_session_detail_states.dart';

class HomeSessionBloc extends Bloc<HomeSessionDetailEvents, HomeSessionStates> {
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();

  final StudentBaseRepository _studentBaseRepo =
      DI.inject<StudentBaseRepository>();
  String teacherId = "";

  HomeSessionBloc() : super(SessionDetailInitialState()) {
    on<FetchSessionDetailEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await fetchSessionDetails(event, emit);
    });

    on<FetchStudentDetailsEvent>((event, emit) async {
      await fetchStudentDetails(event, emit);
    });

    on<FetchTeacherDetailsEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await fetchTeacherDetail(event, emit);
    });

    on<FetchProfilePercentageInfoEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await getProfileCompletionInfo(event, emit);
    });

    on<FetchTeacherSessionCountEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      try{
        emit(FetchTeacherSessionCountLoadingState());
        final response = await _teacherBaseRepository.fetchTeacherSessionCount(teacherId);
        emit(FetchTeacherSessionCountSuccessState(sessionCountResponseModel: response));
      } catch(exception) {
        emit(FetchTeacherSessionCountFailureState());
      }
    });
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
      } else {
        emit(FetchingProfileCompletionInfoFailureState(
            msg: "Something went wrong"));
      }
    }
  }

  Future<void> fetchSessionDetails(event, emit) async {
    emit(FetchingSessionDetailState());
    try {
      if (event is FetchSessionDetailEvent) {
        final listOfSessionDetailResponse = await _teacherBaseRepository
            .getSessionDetails(teacherId, event.type);
        emit(FetchedSessionDetailState(
            sessionDetailResponse: listOfSessionDetailResponse));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingSessionDetailFailureState(
            message: exception.message.toString());
      } else {
        FetchingSessionDetailFailureState(message: "Something Went Wrong");
      }
    }
  }

  Future<void> fetchStudentDetails(event, emit) async {
    emit(FetchingStudentDetailsState());
    try {
      if (event is FetchStudentDetailsEvent) {
        final studentDetails =
            await _studentBaseRepo.fetchStudentDetails(event.studentId);
        emit(FetchedStudentDetailState(studentDetails: studentDetails));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingStudentDetailFailureState(
            message: exception.message.toString());
      } else {
        FetchingStudentDetailFailureState(message: "Something Went Wrong");
      }
    }
  }

  Future<void> fetchTeacherDetail(event, emit) async {
    emit(FetchingTeacherDetailsState());
    try {
      if (event is FetchTeacherDetailsEvent) {
        final teacherDetails =
            await _teacherBaseRepository.getTeachersDetail(teacherId);
        emit(FetchedTeacherDetailState(teacherDetails: teacherDetails));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingTeacherDetailFailureState(
            message: exception.message.toString());
      } else {
        FetchingTeacherDetailFailureState(message: "Something Went Wrong");
      }
    }
  }
}
