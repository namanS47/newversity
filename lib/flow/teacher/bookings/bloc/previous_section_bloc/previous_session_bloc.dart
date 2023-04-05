import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../di/di_initializer.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../home/model/session_response_model.dart';
import '../../../webservice/teacher_base_repository.dart';

part 'previous_session_event.dart';

part 'previous_session_state.dart';

class PreviousSessionBloc
    extends Bloc<PreviousSessionEvents, PreviousSessionStates> {
  int selectedTimeFilterIndex = -1;
  String teacherId = "";
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();
  List<String> timeFilter = [
    "This week",
    "Last week",
    "Last month",
    "This month"
  ];

  int selectedSortByIndex = 0;
  List<String> sortBy = ["Earliest first", "15 min slot", "30 min slot"];

  PreviousSessionBloc() : super(PreviousSessionInitialState()) {
    on<OnSelectTimeRangeChipEvent>((event, emit) async {
      await updateTimeRangeChip(event, emit);
    });

    on<OnChangeSortByIndexEvent>((event, emit) async {
      await updateSortByIndex(event, emit);
    });

    on<FetchAllPreviousSessionsEvent>((event, emit) async {
      teacherId = CommonUtils().getLoggedInUser();
      await fetchSessionDetails(event, emit);
    });
  }

  Future<void> fetchSessionDetails(event, emit) async {
    emit(FetchingPreviousSessionState());
    try {
      if (event is FetchAllPreviousSessionsEvent) {
        final listOfSessionDetailResponse = await _teacherBaseRepository
            .getSessionDetails(teacherId, event.type);
        emit(FetchedPreviousSessionState(
            listOfPreviousSession: listOfSessionDetailResponse));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        FetchingPreviousSessionFailureState(msg: exception.message.toString());
      } else {
        FetchingPreviousSessionFailureState(msg: "Something Went Wrong");
      }
    }
  }

  Future<void> updateSortByIndex(event, emit) async {
    if (event is OnChangeSortByIndexEvent) {
      selectedSortByIndex = event.index;
      emit(UpdatedSortByIndexState());
    }
  }

  Future<void> updateTimeRangeChip(event, emit) async {
    if (event is OnSelectTimeRangeChipEvent) {
      selectedTimeFilterIndex = event.index;
      emit(UpdatedTimeRageIndexState());
    }
  }
}
