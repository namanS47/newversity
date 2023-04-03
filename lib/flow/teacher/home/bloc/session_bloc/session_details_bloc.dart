import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/home/model/repo/SessionRepository.dart';
import 'package:newversity/flow/teacher/home/model/session_request_model.dart';
import 'package:newversity/flow/teacher/home/model/session_response_model.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../../../di/di_initializer.dart';

part 'session_detail_events.dart';

part 'session_detail_states.dart';

class SessionDetailsBloc
    extends Bloc<SessionDetailEvents, SessionDetailStates> {
  final SessionRepository _sessionRepository = DI.inject<SessionRepository>();

  SessionDetailsBloc() : super(SessionDetailInitialState()) {
    on<FetchSessionDetailEvent>((event, emit) {
      fetchSessionDetails(event, emit);
    });

    on<FetchStudentDetailsEvent>((event, emit) {
      fetchSessionDetails(event, emit);
    });

    on<SessionAddingEvent>((event, emit) {
      fetchSessionDetails(event, emit);
    });
  }

  Future<void> saveSessionDetail(event, emit) async {
    emit(SavingSessionDetailState());
    try {
      if (event is SessionAddingEvent) {
        await _sessionRepository.saveSessionDetail(event.sessionSaveRequest);
        emit(SavedSessionDetails());
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        SavingSessionDetailFailureState(message: exception.message.toString());
      } else {
        SavingSessionDetailFailureState(message: "Something Went Wrong");
      }
    }
  }

  Future<void> fetchSessionDetails(event, emit) async {
    emit(FetchingSessionDetailState());
    try {
      if (event is FetchSessionDetailEvent) {
        final listOfSessionDetailResponse =
            await _sessionRepository.getSessionDetails(event.type);
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
            await _sessionRepository.getStudentDetails(event.studentId);
        emit(FetchedStudentDetailState(studentDetails: studentDetails));
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
}
