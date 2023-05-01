import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/student/student_session/my_session/model/session_detail_response_model.dart';
import 'package:newversity/flow/student/webservice/student_base_repository.dart';
import 'package:newversity/flow/teacher/home/model/session_request_model.dart';

import '../../../../../di/di_initializer.dart';
import '../../../../../network/webservice/exception.dart';

part 'student_session_deatil_states.dart';

part 'student_session_detail_events.dart';

class StudentSessionDetailBloc
    extends Bloc<StudentSessionDetailEvents, StudentSessionDetailStates> {
  final StudentBaseRepository _studentBaseRepository =
      DI.inject<StudentBaseRepository>();

  StudentSessionDetailBloc() : super(StudentSessionDetailInitialState()) {
    on<FetchStudentSessionDetailEvent>((event, emit) async {
      await fetchStudentSessionDetail(event, emit);
    });
    on<SaveStudentRatingForSessionEvent>((event, emit) async {
      await saveStudentRatingForSession(event, emit);
    });
    on<SaveStudentReviewForSessionEvent>((event, emit) async {
      await saveStudentReviewForSession(event, emit);
    });

    on<RaiseIssueForSessionEvent>((event, emit) async {
      await raiseIssueForSession(event, emit);
    });
  }

  Future<void> fetchStudentSessionDetail(FetchStudentSessionDetailEvent event,
      Emitter<StudentSessionDetailStates> emit) async {
    emit(FetchingStudentSessionDetailState());
    try {
      final sessionDetailResponseModel =
          await _studentBaseRepository.getSessionDetailWithId(event.sessionId);
      if (sessionDetailResponseModel != null) {
        emit(FetchedStudentSessionDetailState(
            sessionDetailResponseModel: sessionDetailResponseModel));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingStudentSessionDetailFailureState(
            msg: exception.message.toString());
      } else {
        FetchingStudentSessionDetailFailureState(msg: "Something Went Wrong");
      }
    }
  }

  Future<void> saveStudentRatingForSession(
      SaveStudentRatingForSessionEvent event,
      Emitter<StudentSessionDetailStates> emit) async {
    emit(SavingStudentRatingState());
    try {
      await _studentBaseRepository.saveSessionDetail(event.sessionSaveRequest);
      emit(SavedStudentRatingState());
    } catch (exception) {
      if (exception is BadRequestException) {
        SavingStudentRatingFailureState(message: exception.message.toString());
      } else {
        SavingStudentRatingFailureState(message: "Something Went Wrong");
      }
    }
  }

  Future<void> raiseIssueForSession(RaiseIssueForSessionEvent event,
      Emitter<StudentSessionDetailStates> emit) async {
    emit(RaisingSessionIssueState());
    try {
      await _studentBaseRepository.saveSessionDetail(event.sessionSaveRequest);
      emit(RaisedSessionIssueState());
    } catch (exception) {
      if (exception is BadRequestException) {
        RaisingSessionIssueFailureState(msg: exception.message.toString());
      } else {
        RaisingSessionIssueFailureState(msg: "Something Went Wrong");
      }
    }
  }

  Future<void> saveStudentReviewForSession(
      SaveStudentReviewForSessionEvent event,
      Emitter<StudentSessionDetailStates> emit) async {
    emit(SavingStudentReviewState());
    try {
      await _studentBaseRepository.saveSessionDetail(event.sessionSaveRequest);
      emit(SavedStudentReviewState());
    } catch (exception) {
      if (exception is BadRequestException) {
        SavingStudentReviewFailureState(message: exception.message.toString());
      } else {
        SavingStudentReviewFailureState(message: "Something Went Wrong");
      }
    }
  }
}
