import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/selected_datetime_model.dart';
import 'package:newversity/flow/teacher/availability/data/model/fetch_availability_request_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/utils/date_time_utils.dart';

import '../../../../../di/di_initializer.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../../teacher/availability/data/model/availability_model.dart';
import '../../../../teacher/home/model/session_request_model.dart';
import '../../../../teacher/profile/model/education_response_model.dart';
import '../../../../teacher/profile/model/experience_response_model.dart';
import '../data/booking_session_repo.dart';

part 'student_session_events.dart';

part 'student_session_states.dart';

class StudentSessionBloc
    extends Bloc<StudentSessionEvents, StudentSessionStates> {
  double? amount = 0;
  String? sessionType = "short";
  DateTime selectedDate = DateTime.now();
  int selectedDateIndex = 0;
  String? availabilityId;
  List<AvailabilityModel> availabilityList = [];
  Map<String, List<AvailabilityModel>> dateTimeMap = {};
  SelectedDateTimeModel? selectedDateTimeModel;
  int selectedTabIndex = 0;
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

    on<FetchTeacherSessionTimingsEvent>((event, emit) async {
      await fetchTeacherTimingEvent(event, emit);
    });

    on<UpdateDateIndexOfAvailabilityEvent>((event, emit) async {
      await updateAvailabilityIndex(event, emit);
    });

    on<UpdateSelectedDateTimeEvent>((event, emit) async {
      updateSelectedDateTime(event, emit);
    });

    on<SessionAddingEvent>((event, emit) async {
      await saveSessionDetail(event, emit);
    });
  }

  Future<void> saveSessionDetail(
      SessionAddingEvent event, Emitter<StudentSessionStates> emit) async {
    emit(BookingSessionState());
    try {
      await _studentBookingRepo.saveSessionDetail(event.sessionSaveRequest);
      emit(BookedSessionState());
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(BookingSessionFailureState(msg: exception.message.toString()));
      } else {
        emit(BookingSessionFailureState(msg: "Something Went Wrong"));
      }
    }
  }

  Future<void> onUpdateTabIndex(
      UpdateTabBarEvent event, Emitter<StudentSessionStates> emit) async {
    selectedTabIndex = event.index;
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
      if (response != null && response.isNotEmpty) {
        Map<String, List<AvailabilityModel>> mapOfDateTime = {};
        for (var element in response) {
          if (mapOfDateTime.containsKey(
              DateTimeUtils.getBirthFormattedDateTime(element.startDate!))) {
            mapOfDateTime[
                    DateTimeUtils.getBirthFormattedDateTime(element.startDate!)]
                ?.add(element);
          } else {
            List<AvailabilityModel> lisOfAvailabilityModel = [];
            lisOfAvailabilityModel.add(element);
            mapOfDateTime[DateTimeUtils.getBirthFormattedDateTime(
                element.startDate!)] = lisOfAvailabilityModel;
          }
        }
        dateTimeMap = mapOfDateTime;
        emit(FetchedTeacherAvailabilityState(availabilityList: dateTimeMap));
      } else {
        emit(NotTeacherSlotFoundState());
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

  Future<void> updateAvailabilityIndex(UpdateDateIndexOfAvailabilityEvent event,
      Emitter<StudentSessionStates> emit) async {
    selectedDateIndex = event.index;
    emit(UpdatedAvailabilityIndexState());
  }

  Future<void> fetchTeacherTimingEvent(FetchTeacherSessionTimingsEvent event,
      Emitter<StudentSessionStates> emit) async {
    try {
      emit(FetchingTeacherSessionTimingsState());
      final response = await _studentBookingRepo
          .fetchAvailability(event.fetchAvailabilityRequestModel);
      if (response != null) {
        emit(FetchedTeacherSessionTimingsState(availabilityList: response));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTeacherSessionTimingsFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingTeacherSessionTimingsFailureState(
            msg: "Something went wrong"));
      }
    }
  }

  void updateSelectedDateTime(
      UpdateSelectedDateTimeEvent event, Emitter<StudentSessionStates> emit) {
    selectedDateTimeModel = event.currentSelectedDateTime;
    emit(UpdateSelectedDateTimeIndexState());
  }
}
