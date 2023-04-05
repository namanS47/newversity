import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../di/di_initializer.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../home/model/session_response_model.dart';
import '../../../webservice/teacher_base_repository.dart';

part 'upcoming_session_event.dart';

part 'upcoming_session_state.dart';

class UpcomingSessionBloc
    extends Bloc<UpcomingSessionEvent, UpcomingSessionStates> {
  int selectedSortByIndex = 0;
  int selectedTimeFilterIndex = -1;
  String teacherId = "";
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();

  List<String> sortBy = ["Earliest first", "15 min slot", "30 min slot"];

  List<String> timeFilter = [
    "This week",
    "Last week",
    "Last month",
    "This month"
  ];

  UpcomingSessionBloc() : super(UpcomingSessionInitialState()) {
    on<OnSelectTimeRangeChipEvent>((event, emit) async {
      await updateTimeRangeChip(event, emit);
    });

    on<OnChangeSortByIndexEvent>((event, emit) async {
      await updateSortByIndex(event, emit);
    });

    on<FetchAllUpcomingSessionsEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await fetchSessionDetails(event, emit);
    });
  }

  Future<void> updateSortByIndex(event, emit) async {
    if (event is OnChangeSortByIndexEvent) {
      selectedSortByIndex = event.index;
      emit(UpdatedSortByIndexState());
    }
  }

  Future<void> fetchSessionDetails(event, emit) async {
    emit(FetchingUpcomingSessionState());
    try {
      if (event is FetchAllUpcomingSessionsEvent) {
        final listOfSessionDetailResponse = await _teacherBaseRepository
            .getSessionDetails(teacherId, event.type);
        emit(FetchedUpcomingSessionState(
            sessionDetailResponse: listOfSessionDetailResponse));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingUpcomingSessionFailureState(msg: exception.message.toString());
      } else {
        FetchingUpcomingSessionFailureState(msg: "Something Went Wrong");
      }
    }
  }

  Future<void> updateTimeRangeChip(event, emit) async {
    if (event is OnSelectTimeRangeChipEvent) {
      selectedTimeFilterIndex = event.index;
      emit(UpdatedTimeRageIndexState());
    }
  }
}
