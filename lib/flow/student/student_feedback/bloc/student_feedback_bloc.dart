import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../di/di_initializer.dart';
import '../../../../network/webservice/exception.dart';
import '../../../teacher/home/model/session_request_model.dart';
import '../../webservice/student_base_repository.dart';

part 'student_feedback_event.dart';

part 'student_feedback_state.dart';

class StudentFeedbackBloc
    extends Bloc<StudentFeedbackEvent, StudentFeedbackState> {
  final StudentBaseRepository _studentBaseRepository =
      DI.inject<StudentBaseRepository>();

  StudentFeedbackBloc() : super(StudentFeedbackInitial()) {
    on<SaveStudentFeedbackEvent>((event, emit) async {
      emit(SaveStudentFeedbackLoadingState());
      try {
        await _studentBaseRepository.saveSessionDetail(event.sessionSaveRequest);
        emit(SaveStudentFeedbackSuccessState(shouldPopScreen: !event.forRating));
      } catch (exception) {
        if (exception is BadRequestException) {
          SaveStudentFeedbackFailureState(errorMessage: exception.message.toString());
        } else {
          SaveStudentFeedbackFailureState(errorMessage: "Something Went Wrong");
        }
      }
    });
  }
}
