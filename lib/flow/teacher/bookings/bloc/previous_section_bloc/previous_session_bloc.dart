import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'previous_session_event.dart';

part 'previous_session_state.dart';

class PreviousSessionBloc
    extends Bloc<PreviousSessionEvents, PreviousSessionStates> {
  int selectedTimeFilterIndex = -1;
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
