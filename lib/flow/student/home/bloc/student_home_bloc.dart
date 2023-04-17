import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';

import '../../../../common/common_utils.dart';
import '../../../../di/di_initializer.dart';
import '../../../../network/webservice/exception.dart';
import '../../student_session/my_session/model/session_detail_response_model.dart';
import '../../webservice/student_base_repository.dart';

part 'student_home_events.dart';

part 'student_home_states.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvents, StudentHomeStates> {
  List<SessionDetailResponseModel> listOfUpcomingSessions = [];

  String studentId = CommonUtils().getLoggedInUser();

  final StudentBaseRepository _studentBaseRepository =
      DI.inject<StudentBaseRepository>();

  int currentNextSessionIndex = 0;

  StudentHomeBloc() : super(StudentHomeInitialState()) {
    on<UpdatedNextSessionIndexEvent>((event, emit) async {
      updateNextSessionCarouselIndex(event, emit);
    });

    on<FetchStudentDetailEvent>((event, emit) async {
      await fetchStudentDetail(event, emit);
    });

    on<FetchUpcomingSessionEvent>((event, emit) async {
      await fetchStudentUpcomingSession(event, emit);
    });

    on<FetchMentorsByTagEvent>((event, emit) async {
      await fetchMentorsByTag(event, emit);
    });
  }

  void updateNextSessionCarouselIndex(event, emit) {
    if (event is UpdatedNextSessionIndexEvent) {
      currentNextSessionIndex = event.nextIndex;
      emit(UpdatedNextSessionIndexState());
    }
  }

  Future<void> fetchStudentDetail(
      FetchStudentDetailEvent event, Emitter<StudentHomeStates> emit) async {
    emit(FetchingStudentDetailsState());
    try {
      final studentDetails =
          await _studentBaseRepository.fetchStudentDetails(studentId);
      emit(FetchedStudentDetailsState(studentDetail: studentDetails));
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingStudentDetailsFailureState(msg: exception.message.toString());
      } else {
        FetchingStudentDetailsFailureState(msg: "Something Went Wrong");
      }
    }
  }

  Future<void> fetchStudentUpcomingSession(
      FetchUpcomingSessionEvent event, Emitter<StudentHomeStates> emit) async {
    try {
      emit(FetchingStudentUpcomingSessionState());
      final listOfSessionDetailResponse = await _studentBaseRepository
          .getSessionDetails(studentId, event.sessionType);
      if (listOfSessionDetailResponse != null &&
          listOfSessionDetailResponse.isNotEmpty) {
        listOfUpcomingSessions = listOfSessionDetailResponse;
        emit(FetchedStudentUpcomingSessionState());
      } else if (listOfSessionDetailResponse != null ||
          listOfSessionDetailResponse!.isEmpty) {
        emit(StudentHomeUpcomingSessionNotFoundState());
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingStudentUpcomingSessionFailureState(
            msg: exception.message.toString());
      } else {
        FetchingStudentUpcomingSessionFailureState(msg: "Something Went Wrong");
      }
    }
  }

  Future<void> fetchMentorsByTag(
      FetchMentorsByTagEvent event, Emitter<StudentHomeStates> emit) async {
    try {
      emit(FetchingMentorsWithTagState());
      final listOfTeachersResponse = await _studentBaseRepository
          .getTeacherDetailsWithTags(event.tagRequestModel);
      if (listOfTeachersResponse != null && listOfTeachersResponse.isNotEmpty) {
        emit(FetchedMentorsWithTagState(
            lisOfTeacherDetails: listOfTeachersResponse));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingMentorsWithTagFailureState(msg: exception.message.toString());
      } else {
        FetchingMentorsWithTagFailureState(msg: "Something Went Wrong");
      }
    }
  }
}
