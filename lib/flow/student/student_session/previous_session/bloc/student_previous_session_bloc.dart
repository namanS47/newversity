import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../di/di_initializer.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../webservice/student_base_repository.dart';
import '../../my_session/model/session_detail_response_model.dart';

part 'student_previous_session_events.dart';

part 'student_previous_session_states.dart';

class StudentPreviousSessionBloc
    extends Bloc<StudentPreviousSessionEvents, StudentPreviousSessionState> {
  String studentId = CommonUtils().getLoggedInUser();

  final StudentBaseRepository _studentBaseRepository =
      DI.inject<StudentBaseRepository>();

  StudentPreviousSessionBloc() : super(StudentPreviousSessionInitialState()) {
    on<FetchStudentPreviousSessionEvent>((event, emit) async {
      await fetchStudentPreviousSession(event, emit);
    });
  }

  Future<void> fetchStudentPreviousSession(
      FetchStudentPreviousSessionEvent event,
      Emitter<StudentPreviousSessionState> emit) async {
    emit(FetchingStudentPreviousSessionState());
    try {
      final listOfSessionDetailResponse = await _studentBaseRepository
          .getSessionDetails(studentId, event.sessionType);
      if (listOfSessionDetailResponse != null &&
          listOfSessionDetailResponse.isNotEmpty) {
        emit(FetchedStudentPreviousSessionState(
            listOfPreviousSession: listOfSessionDetailResponse));
      } else if (listOfSessionDetailResponse != null &&
          listOfSessionDetailResponse.isEmpty) {
        emit(PreviousDataNotFoundState());
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingStudentPreviousSessionFailureState(
            msg: exception.message.toString());
      } else {
        FetchingStudentPreviousSessionFailureState(msg: "Something Went Wrong");
      }
    }
  }
}
