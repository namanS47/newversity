import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'upcoming_session_event.dart';

part 'upcoming_session_state.dart';

class UpcomingSessionBloc
    extends Bloc<UpcomingSessionEvent, UpcomingSessionStates> {
  int selectedSortByIndex = 0;
  int selectedTimeFilterIndex = -1;

  List<String> sortBy = ["Earliest first", "15 min slot", "30 min slot"];

  List<String> timeFilter = [
    "This week",
    "Last week",
    "Last month",
    "This month"
  ];

  UpcomingSessionBloc() : super(UpcomingSessionInitialState()) {
    on<OnSelectTimeRangeChipEvent>((event, emit) async {
      updateTimeRangeChip(event, emit);
    });

    on<OnChangeSortByIndexEvent>((event, emit) async {
      updateSortByIndex(event, emit);
    });
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
