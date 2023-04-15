import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/student/home/model/session_details.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';

import '../../../../common/common_utils.dart';
import '../../../../di/di_initializer.dart';
import '../../../../network/webservice/exception.dart';
import '../../webservice/student_base_repository.dart';

part 'student_home_events.dart';

part 'student_home_states.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvents, StudentHomeStates> {
  List<SessionDetails> listOfSessionDetails =
      SessionDetails.listOdSessionDetails;

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
}
