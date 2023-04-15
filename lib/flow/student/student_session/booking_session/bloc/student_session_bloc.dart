import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/teacher/availability/data/model/fetch_availability_request_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';

import '../../../../../di/di_initializer.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../../teacher/availability/data/model/availability_model.dart';
import '../../../../teacher/profile/model/education_response_model.dart';
import '../../../../teacher/profile/model/experience_response_model.dart';
import '../data/booking_session_repo.dart';

part 'student_session_events.dart';

part 'student_session_states.dart';

class StudentSessionBloc
    extends Bloc<StudentSessionEvents, StudentSessionStates> {
  int selectedSessionIndex = 0;
  final SessionBookingRepository _studentBookingRepo =
      DI.inject<SessionBookingRepository>();

  List<String> sessionCategory = ["About", "Availability", "Reviews"];

  StudentSessionBloc() : super(StudentSessionInitialState()) {
    on<UpdateTabBarEvent>((event, emit) async {
      await onUpdateTabIndex(event, emit);
    });

    on<FetchTeacherDetailsEvent>((event, emit) async {
      await fetchTeacherDetails(event, emit);
    });

    on<FetchTeacherEducationEvent>((event, emit) async {
      await fetchTeacherEducation(event, emit);
    });

    on<FetchTeacherExperienceEvent>((event, emit) async {
      await fetchTeacherExperience(event, emit);
    });

    on<FetchTeacherAvailabilityEvent>((event, emit) async {
      await fetchTeacherAvailability(event, emit);
    });
  }

  Future<void> onUpdateTabIndex(
      UpdateTabBarEvent event, Emitter<StudentSessionStates> emit) async {
    selectedSessionIndex = event.index;
    emit(UpdatedTabBarState());
  }

  Future<void> fetchTeacherDetails(FetchTeacherDetailsEvent event,
      Emitter<StudentSessionStates> emit) async {
    emit(FetchingTeacherDetailsState());
    try {
      final teacherDetails =
          await _studentBookingRepo.getTeachersDetail(event.teacherId);
      emit(FetchedTeacherDetailsState(teacherDetails: teacherDetails));
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTeacherDetailsFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingTeacherDetailsFailureState(msg: "Something went wrong"));
      }
    }
  }

  Future<void> fetchTeacherEducation(FetchTeacherEducationEvent event,
      Emitter<StudentSessionStates> emit) async {
    emit(FetchingTeacherEducationState());
    try {
      final response = await _studentBookingRepo
          .fetchAllEducationWithTeacherId(event.teacherId);
      if (response != null) {
        emit(FetchedTeacherEducationState(listOfTeacherEducation: response));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTeacherEducationFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingTeacherEducationFailureState(msg: "Something went wrong"));
      }
    }
  }

  Future<void> fetchTeacherExperience(FetchTeacherExperienceEvent event,
      Emitter<StudentSessionStates> emit) async {
    emit(FetchingTeacherExperienceState());
    try {
      final response = await _studentBookingRepo
          .fetchAllExperiencesWithTeacherId(event.teacherId);
      if (response != null) {
        emit(FetchedTeacherExperienceState(listOfTeacherExperience: response));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTeacherExperienceFailureState(
            msg: exception.message.toString()));
      } else {
        emit(
            FetchingTeacherExperienceFailureState(msg: "Something went wrong"));
      }
    }
  }

  Future<void> fetchTeacherAvailability(FetchTeacherAvailabilityEvent event,
      Emitter<StudentSessionStates> emit) async {
    emit(FetchingTeacherAvailabilityState());
    try {
      final response = await _studentBookingRepo
          .fetchAvailability(event.fetchAvailabilityRequestModel);
      if (response != null) {
        emit(FetchedTeacherAvailabilityState(availabilityList: response));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTeacherAvailabilityFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingTeacherAvailabilityFailureState(
            msg: "Something went wrong"));
      }
    }
  }
}
