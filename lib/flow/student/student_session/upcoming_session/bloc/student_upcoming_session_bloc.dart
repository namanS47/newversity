import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../di/di_initializer.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../webservice/student_base_repository.dart';
import '../../my_session/model/session_detail_response_model.dart';

part 'student_upcoming_session_events.dart';

part 'student_upcoming_session_states.dart';

class StudentUpcomingSessionBloc
    extends Bloc<StudentUpcomingSessionEvents, StudentUpcomingSessionStates> {
  String studentId = CommonUtils().getLoggedInUser();

  final StudentBaseRepository _studentBaseRepository =
      DI.inject<StudentBaseRepository>();

  StudentUpcomingSessionBloc() : super(StudentUpcomingSessionInitialState()) {
    on<FetchStudentUpcomingSessionEvent>((event, emit) async {
      await fetchStudentUpcomingSession(event, emit);
    });
  }

  Future<void> fetchStudentUpcomingSession(
      FetchStudentUpcomingSessionEvent event,
      Emitter<StudentUpcomingSessionStates> emit) async {
    try {
      emit(FetchingStudentUpcomingSessionState());
      final listOfSessionDetailResponse = await _studentBaseRepository
          .getSessionDetails(studentId, event.sessionType);
      if (listOfSessionDetailResponse != null &&
          listOfSessionDetailResponse.isNotEmpty) {
        emit(FetchedStudentUpcomingSessionState(
            listOfUpcomingSession: listOfSessionDetailResponse));
      } else if (listOfSessionDetailResponse != null ||
          listOfSessionDetailResponse!.isEmpty) {
        emit(UpcomingDataNotFoundState());
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
}
