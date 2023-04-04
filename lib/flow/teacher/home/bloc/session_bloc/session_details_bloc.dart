import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/home/model/session_response_model.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../di/di_initializer.dart';
import '../../../webservice/teacher_base_repository.dart';

part 'session_detail_events.dart';

part 'session_detail_states.dart';

class SessionBloc extends Bloc<SessionDetailEvents, SessionStates> {
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();
  String teacherId = "";

  SessionBloc() : super(SessionDetailInitialState()) {
    on<FetchSessionDetailEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await fetchSessionDetails(event, emit);
    });

    on<FetchStudentDetailsEvent>((event, emit) async {
      await fetchStudentDetails(event, emit);
    });

    on<FetchTeacherDetailEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await fetchTeacherDetail(event, emit);
    });
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
            await _teacherBaseRepository.getTeachersDetail(event.studentId);
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
      if (event is FetchTeacherDetailEvent) {
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
